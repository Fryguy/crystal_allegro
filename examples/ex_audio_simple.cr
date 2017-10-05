# Crystal port of ex_audio_simple.c from the Allegro examples.

# Example program for the Allegro library.
#
# Demonstrate 'simple' audio interface.

require "../src/crystal_allegro"
require "./common"

include Common

RESERVED_SAMPLES = 16
MAX_SAMPLE_DATA  = 10

class AbortException < Exception
end

class RestartException < Exception
end

begin
  sample_data = Array(LibAllegro::Sample).new(10, Pointer(Void).null.as(LibAllegro::Sample))
  event = uninitialized LibAllegro::Event

  abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

  open_log

  if ARGV.size < 1
    log_printf("This example needs to be run from the command line.\nUsage: %s {audio_files}\n", $0)
    raise AbortException.new
  end

  LibAllegro.install_keyboard

  display = LibAllegro.create_display(640, 480)
  abort_example("Could not create display\n") unless display

  event_queue = LibAllegro.create_event_queue
  LibAllegro.register_event_source(event_queue, LibAllegro.get_keyboard_event_source)

  LibAllegro.init_acodec_addon

  loop do
    begin
      if LibAllegro.install_audio == 0
        abort_example("Could not init sound!\n")
      end

      if LibAllegro.reserve_samples(RESERVED_SAMPLES) == 0
        abort_example("Could not set up voice and mixer.\n")
      end

      loop do |i|
        break if i == ARGV.size || i == MAX_SAMPLE_DATA
        filename = ARGV[i]

        # Load the entire sound file from disk.
        sample_data[i] = LibAllegro.load_sample(filename)
        unless sample_data[i]
          log_printf("Could not load sample from '%s'!\n", filename)
          next
        end
      end

      log_printf("Press digits to play sounds, space to stop sounds, " \
                 "Escape to quit.\n")

      loop do
        LibAllegro.wait_for_event(event_queue, pointerof(event))
        if event.type == LibAllegro::EventKeyChar
          break if event.keyboard.keycode == LibAllegro::KeyEscape
          LibAllegro.stop_samples if event.keyboard.unichar == ' '.ord

          if event.keyboard.unichar >= '0'.ord && event.keyboard.unichar <= '9'.ord
            i = (event.keyboard.unichar - '0'.ord + 9) % 10
            if sample_data[i]
              log_printf("Playing %d\n", i)
              if LibAllegro.play_sample(sample_data[i], 1.0, 0.5, 1.0, LibAllegro::Playmode::PlaymodeLoop, nil) == 0
                log_printf(
                  "LibAllegro.play_sample_data failed, perhaps too many sounds\n")
              end
            end
          end

          # Hidden feature: restart audio subsystem.
          # For debugging race conditions on shutting down the audio.
          if event.keyboard.unichar == 'r'.ord
            LibAllegro.uninstall_audio
            raise RestartException.new
          end
        end
      end

      # Sample data and other objects will be automatically freed.
      LibAllegro.uninstall_audio
      break
    rescue RestartException
    else
    end
  end
rescue AbortException
ensure
  LibAllegro.destroy_display(display)
  close_log(true)
end
