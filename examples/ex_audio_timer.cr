# Crystal port of ex_audio_timer.c from the Allegro examples.

#
# Example program for the Allegro library.
#

require "../src/crystal_allegro"
require "./common"

class ExAudioTimer
  include Common

  RESERVED_SAMPLES = 16
  PERIOD           =  5

  property! display : Pointer(LibAllegro::Display)?
  property! font : LibAllegro::Font?
  property! ping : LibAllegro::Sample?
  property! timer : LibAllegro::Timer*?
  property! event_queue : LibAllegro::EventQueue?

  def create_sample_s16(freq, len)
    buf = CrystalAllegro.malloc(freq * len * sizeof(LibC::Int16T))

    LibAllegro.create_sample(buf, len, freq, LibAllegro::AudioDepth::AudioDepthInt16,
      LibAllegro::ChannelConf::ChannelConf1, 1)
  end

  # Adapted from SPEED.
  def generate_ping
    # ping consists of two sine waves
    len = 8192
    ping = create_sample_s16(22050, len)
    return nil unless ping

    p = LibAllegro.get_sample_data(ping).as(Pointer(LibC::Int16T))

    osc1 = 0.0
    osc2 = 0.0

    len.times do |i|
      vol = (len - i).to_f / len.to_f * 4000

      ramp = i.to_f / len.to_f * 8
      vol *= ramp if ramp < 1.0

      p.value = ((Math.sin(osc1) + Math.sin(osc2) - 1) * vol).to_i16

      osc1 += 0.1
      osc2 += 0.15

      p += 1
    end

    return ping
  end

  def main
    trans = uninitialized LibAllegro::Transform
    event = uninitialized LibAllegro::Event
    bps = 4
    redraw = false
    last_timer = 0

    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    open_log

    LibAllegro.install_keyboard

    display = self.display = LibAllegro.create_display(640, 480)
    abort_example("Could not create display\n") unless display

    font = self.font = LibAllegro.create_builtin_font
    abort_example("Could not create font\n") unless font

    abort_example("Could not init sound\n") unless LibAllegro.install_audio

    if LibAllegro.reserve_samples(RESERVED_SAMPLES) == 0
      abort_example("Could not set up voice and mixer\n")
    end

    ping = self.ping = generate_ping
    abort_example("Could not generate sample\n") unless ping

    self.timer = LibAllegro.create_timer(1.0 / bps)
    LibAllegro.set_timer_count(timer, -1)

    self.event_queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(event_queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(event_queue, LibAllegro.get_timer_event_source(timer))

    LibAllegro.identity_transform(pointerof(trans))
    LibAllegro.scale_transform(pointerof(trans), 16.0, 16.0)
    LibAllegro.use_transform(pointerof(trans))

    LibAllegro.start_timer(timer)

    loop do
      LibAllegro.wait_for_event(event_queue, pointerof(event))
      if event.type == LibAllegro::EventTimer
        speed = (21.0 / 20.0) ** (event.timer.count % PERIOD)
        if LibAllegro.play_sample(ping, 1.0, 0.0, speed, LibAllegro::Playmode::PlaymodeOnce, nil) == 0
          log_printf("Not enough reserved samples.\n")
        end
        redraw = true
        last_timer = event.timer.count.to_i
      elsif event.type == LibAllegro::EventKeyChar
        break if event.keyboard.keycode == LibAllegro::KeyEscape
        if event.keyboard.unichar == '+'.ord || event.keyboard.unichar == '='.ord
          if bps < 32
            bps += 1
            LibAllegro.set_timer_speed(timer, 1.0 / bps)
          end
        elsif event.keyboard.unichar == '-'.ord
          if bps > 1
            bps -= 1
            LibAllegro.set_timer_speed(timer, 1.0 / bps)
          end
        end
      end

      if redraw && LibAllegro.is_event_queue_empty(event_queue) != 0
        if last_timer % PERIOD == 0
          c = LibAllegro.map_rgb_f(1, 1, 1)
        else
          c = LibAllegro.map_rgb_f(0.5, 0.5, 1.0)
        end

        LibAllegro.clear_to_color(LibAllegro.map_rgb(0, 0, 0))
        LibAllegro.draw_textf(font, c, 640 / 32, 480 / 32 - 4, LibAllegro::AlignCentre,
          "%d", last_timer)
        LibAllegro.flip_display
      end
    end

    close_log(false)
  end
end

ExAudioTimer.new.main
