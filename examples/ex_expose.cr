# Crystal port of ex_expose.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

LibAllegro.init_primitives_addon
LibAllegro.init_image_addon
LibAllegro.install_keyboard
LibAllegro.install_mouse
init_platform_specific

LibAllegro.set_new_display_flags(LibAllegro::Resizable |
                                 LibAllegro::GenerateExposeEvents)
LibAllegro.set_new_display_option(LibAllegro::SingleBuffer, 1, LibAllegro::Require)
display = LibAllegro.create_display(320, 200)
abort_example("Error creating display\n") unless display

bitmap = LibAllegro.load_bitmap("data/mysha.pcx")
abort_example("mysha.pcx not found or failed to load\n") unless bitmap
LibAllegro.draw_bitmap(bitmap, 0, 0, 0)
LibAllegro.flip_display

timer = LibAllegro.create_timer(0.1)

queue = LibAllegro.create_event_queue
LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
LibAllegro.start_timer(timer)

event = uninitialized LibAllegro::Event
loop do
  LibAllegro.wait_for_event(queue, pointerof(event))
  case event.type
  when LibAllegro::EventDisplayClose
    break
  when LibAllegro::EventKeyDown
    break if event.keyboard.keycode == LibAllegro::KeyEscape
  when LibAllegro::EventDisplayResize
    LibAllegro.acknowledge_resize(event.display.source)
  when LibAllegro::EventDisplayExpose
    x = event.display.x
    y = event.display.y
    w = event.display.width
    h = event.display.height
    # Draw a red rectangle over the damaged area.
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    LibAllegro.draw_filled_rectangle(x, y, x + w, y + h, LibAllegro.map_rgba_f(1, 0, 0, 1))
    LibAllegro.flip_display
  when LibAllegro::EventTimer
    # Slowly restore the original bitmap.
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::Alpha, LibAllegro::InverseAlpha)
    (0...LibAllegro.get_display_height(display)).step(200) do |y|
      (0...LibAllegro.get_display_width(display)).step(320) do |x|
        LibAllegro.draw_tinted_bitmap(bitmap, LibAllegro.map_rgba_f(1, 1, 1, 0.1), x, y, 0)
      end
    end
    LibAllegro.flip_display
  end
end

LibAllegro.destroy_event_queue(queue)
LibAllegro.destroy_bitmap(bitmap)
