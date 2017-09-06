# Crystal port of ex_disable_screensaver.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

event = uninitialized LibAllegro::Event
done = false
active = true
fullscreen = false

fullscreen = true if ARGV[0]? == "-fullscreen"

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

LibAllegro.install_keyboard
LibAllegro.init_font_addon

LibAllegro.set_new_display_flags(LibAllegro::GenerateExposeEvents |
                                 (fullscreen ? LibAllegro::Fullscreen : 0))

display = LibAllegro.create_display(640, 480)
abort_example("Could not create display.\n") unless display

font = LibAllegro.create_builtin_font
abort_example("Error creating builtin font\n") unless font

events = LibAllegro.create_event_queue
LibAllegro.register_event_source(events, LibAllegro.get_keyboard_event_source)
# For expose events
LibAllegro.register_event_source(events, LibAllegro.get_display_event_source(display))

until done
  LibAllegro.clear_to_color(LibAllegro.map_rgb(0, 0, 0))
  LibAllegro.draw_textf(font, LibAllegro.map_rgb_f(1, 1, 1), 0, 0, 0,
    "Screen saver: %s", active ? "Normal" : "Inhibited")
  LibAllegro.flip_display
  LibAllegro.wait_for_event(events, pointerof(event))
  case event.type
  when LibAllegro::EventKeyDown
    if event.keyboard.keycode == LibAllegro::KeyEscape
      done = true
    elsif event.keyboard.keycode == LibAllegro::KeySpace
      if LibAllegro.inhibit_screensaver(active ? 0 : 1)
        active = !active
      end
    end
  end
end

LibAllegro.destroy_font(font)
LibAllegro.destroy_event_queue(events)
