# Crystal port of ex_dualies.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

def go
  event = uninitialized LibAllegro::Event

  LibAllegro.set_new_display_flags(LibAllegro::Fullscreen)

  LibAllegro.set_new_display_adapter(0)
  d1 = LibAllegro.create_display(640, 480)
  abort_example("Error creating first display\n") unless d1
  b1 = LibAllegro.load_bitmap("data/mysha.pcx")
  abort_example("Error loading mysha.pcx\n") unless b1

  LibAllegro.set_new_display_adapter(1)
  d2 = LibAllegro.create_display(640, 480)
  abort_example("Error creating second display\n") unless d2
  b2 = LibAllegro.load_bitmap("data/allegro.pcx")
  abort_example("Error loading allegro.pcx\n") unless b2

  queue = LibAllegro.create_event_queue
  LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)

  loop do
    if LibAllegro.is_event_queue_empty(queue) != 0
      LibAllegro.get_next_event(queue, pointerof(event))
      if event.type == LibAllegro::EventKeyDown
        if event.keyboard.keycode == LibAllegro::KeyEscape
          break
        end
      end
    end

    LibAllegro.set_target_backbuffer(d1)
    LibAllegro.draw_scaled_bitmap(b1, 0, 0, 320, 200, 0, 0, 640, 480, 0)
    LibAllegro.flip_display

    LibAllegro.set_target_backbuffer(d2)
    LibAllegro.draw_scaled_bitmap(b2, 0, 0, 320, 200, 0, 0, 640, 480, 0)
    LibAllegro.flip_display

    LibAllegro.rest(0.1)
  end

  LibAllegro.destroy_bitmap(b1)
  LibAllegro.destroy_bitmap(b2)
  LibAllegro.destroy_display(d1)
  LibAllegro.destroy_display(d2)
end

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

LibAllegro.install_keyboard

LibAllegro.init_image_addon

abort_example("You need 2 or more adapters/monitors for this example.\n") if LibAllegro.get_num_video_adapters < 2

go
