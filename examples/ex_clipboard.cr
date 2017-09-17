# Crystal port of ex_clipboard.c from the Allegro examples.

# An example showing bitmap flipping flags, by Steven Wallace.

require "../src/crystal_allegro"
require "./common"

include Common

INTERVAL = 0.1

text = nil
done = false
redraw = true

abort_example("Failed to init Allegro.\n") unless CrystalAllegro.init

if LibAllegro.init_image_addon == 0
  abort_example("Failed to init IIO addon.\n")
end

LibAllegro.init_font_addon
init_platform_specific

display = LibAllegro.create_display(640, 480)
abort_example("Error creating display.\n") unless display

if LibAllegro.install_keyboard == 0
  abort_example("Error installing keyboard.\n")
end

font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
abort_example("Error loading data/fixed_font.tga\n") unless font

timer = LibAllegro.create_timer(INTERVAL)

queue = LibAllegro.create_event_queue
LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))

LibAllegro.start_timer(timer)

LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)

until done
  event = uninitialized LibAllegro::Event

  if redraw && LibAllegro.is_event_queue_empty(queue) != 0
    CrystalAllegro.free(text) if text
    if LibAllegro.clipboard_has_text(display)
      text = LibAllegro.get_clipboard_text(display)
    else
      text = nil
    end

    LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))

    if text
      LibAllegro.draw_text(font, LibAllegro.map_rgba_f(1, 1, 1, 1.0), 0, 0, 0, text)
    else
      LibAllegro.draw_text(font, LibAllegro.map_rgba_f(1, 0, 0, 1.0), 0, 0, 0,
        "No clipboard text available.")
    end
    LibAllegro.flip_display
    redraw = false
  end

  LibAllegro.wait_for_event(queue, pointerof(event))
  case event.type
  when LibAllegro::EventKeyDown
    if event.keyboard.keycode == LibAllegro::KeyEscape
      done = true
    elsif event.keyboard.keycode == LibAllegro::KeySpace
      LibAllegro.set_clipboard_text(display, "Copied from Allegro!")
    end
  when LibAllegro::EventDisplayClose
    done = true
  when LibAllegro::EventTimer
    redraw = true
  end
end

LibAllegro.destroy_font(font)
