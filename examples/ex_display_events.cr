# Crystal port of ex_display_events.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExDisplayEvents
  include Common

  MAX_EVENTS = 23

  property events = [] of String

  def add_event(format, *args)
    events.pop if events.size == MAX_EVENTS
    events.unshift(format % args)
  end

  def main
    event = uninitialized LibAllegro::Event

    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    LibAllegro.init_primitives_addon
    LibAllegro.install_mouse
    LibAllegro.install_keyboard
    LibAllegro.init_font_addon

    LibAllegro.set_new_display_flags(LibAllegro::Resizable)
    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    font = LibAllegro.create_builtin_font
    abort_example("Error creating builtin font\n") unless font

    black = LibAllegro.map_rgb_f(0, 0, 0)
    red = LibAllegro.map_rgb_f(1, 0, 0)
    blue = LibAllegro.map_rgb_f(0, 0, 1)

    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))

    loop do
      if LibAllegro.is_event_queue_empty(queue)
        x = 8.0
        y = 28.0
        LibAllegro.clear_to_color(LibAllegro.map_rgb(0xff, 0xff, 0xc0))

        LibAllegro.draw_textf(font, blue, 8, 8, 0, "Display events (newest on top)")

        color = red
        events.each do |event|
          LibAllegro.draw_textf(font, color, x, y, 0, "%s" % event)
          color = black
          y += 20
        end
        LibAllegro.flip_display
      end

      LibAllegro.wait_for_event(queue, pointerof(event))
      case event.type
      when LibAllegro::EventMouseEnterDisplay
        add_event("LibAllegro::EventMouseEnterDisplay")
      when LibAllegro::EventMouseLeaveDisplay
        add_event("LibAllegro::EventMouseLeaveDisplay")
      when LibAllegro::EventKeyDown
        break if event.keyboard.keycode == LibAllegro::KeyEscape
      when LibAllegro::EventDisplayResize
        add_event("LibAllegro::EventDisplayResize x=%d, y=%d, " \
                  "width=%d, height=%d",
          event.display.x, event.display.y, event.display.width,
          event.display.height)
        LibAllegro.acknowledge_resize(event.display.source)
      when LibAllegro::EventDisplayClose
        add_event("LibAllegro::EventDisplayClose")
      when LibAllegro::EventDisplayLost
        add_event("LibAllegro::EventDisplayLost")
      when LibAllegro::EventDisplayFound
        add_event("LibAllegro::EventDisplayFound")
      when LibAllegro::EventDisplaySwitchOut
        add_event("LibAllegro::EventDisplaySwitchOut")
      when LibAllegro::EventDisplaySwitchIn
        add_event("LibAllegro::EventDisplaySwitchIn")
      end
    end

    LibAllegro.destroy_event_queue(queue)
  end
end

ExDisplayEvents.new.main
