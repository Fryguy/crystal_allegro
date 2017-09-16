# Crystal port of ex_fs_resize.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExFsResize
  include Common

  NUM_RESOLUTIONS = 4

  struct Resolution
    property w : Int32
    property h : Int32

    def initialize(@w, @h)
    end
  end

  RES = [
    Resolution.new(640, 480),
    Resolution.new(800, 600),
    Resolution.new(1024, 768),
    Resolution.new(1280, 1024),
  ]

  property cur_res = 0

  def redraw(picture)
    target = LibAllegro.get_target_bitmap
    w = LibAllegro.get_bitmap_width(target)
    h = LibAllegro.get_bitmap_height(target)

    color = LibAllegro.map_rgb(
      128 + rand(128),
      128 + rand(128),
      128 + rand(128)
    )
    LibAllegro.clear_to_color(color)

    color = LibAllegro.map_rgb(255, 0, 0)
    LibAllegro.draw_line(0, 0, w, h, color, 0)
    LibAllegro.draw_line(0, h, w, 0, color, 0)

    LibAllegro.draw_bitmap(picture, 0, 0, 0)
    LibAllegro.flip_display
  end

  def main_loop(display, picture)
    event = uninitialized LibAllegro::Event

    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))

    can_draw = true

    loop do
      redraw(picture) if LibAllegro.is_event_queue_empty(queue) && can_draw
      LibAllegro.wait_for_event(queue, pointerof(event))

      if event.type == LibAllegro::EventDisplayLost
        log_printf("Display lost\n")
        can_draw = false
        next
      end
      if event.type == LibAllegro::EventDisplayFound
        log_printf("Display found\n")
        can_draw = true
        next
      end
      next if event.type != LibAllegro::EventKeyChar

      break if event.keyboard.keycode == LibAllegro::KeyEscape

      new_res = cur_res

      if event.keyboard.unichar == '+'.ord ||
         event.keyboard.unichar == ' '.ord ||
         event.keyboard.keycode == LibAllegro::KeyEnter
        new_res += 1
        new_res = 0 if new_res >= NUM_RESOLUTIONS
      elsif event.keyboard.unichar == '-'.ord
        new_res -= 1
        new_res = NUM_RESOLUTIONS - 1 if new_res < 0
      end

      if new_res != cur_res
        self.cur_res = new_res
        log_printf("Switching to %dx%d... ", RES[cur_res].w, RES[cur_res].h)
        if LibAllegro.resize_display(display, RES[cur_res].w, RES[cur_res].h)
          log_printf("Succeeded.\n")
        else
          log_printf("Failed. current resolution: %dx%d\n",
            LibAllegro.get_display_width(display), LibAllegro.get_display_height(display))
        end
      end
    end

    LibAllegro.destroy_event_queue(queue)
  end

  def main
    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init
    LibAllegro.init_primitives_addon
    LibAllegro.install_keyboard
    LibAllegro.init_image_addon
    init_platform_specific

    open_log_monospace

    LibAllegro.set_new_display_adapter(ARGV[0].to_i) if ARGV.size == 1

    LibAllegro.set_new_display_flags(LibAllegro::Fullscreen |
                                     LibAllegro::GenerateExposeEvents)
    display = LibAllegro.create_display(RES[cur_res].w, RES[cur_res].h)
    abort_example("Error creating display\n") unless display

    picture = LibAllegro.load_bitmap("data/mysha.pcx")
    abort_example("mysha.pcx not found\n") unless picture

    main_loop(display, picture)

    LibAllegro.destroy_bitmap(picture)

    # Destroying the fullscreen display restores the original screen
    # resolution.  Shutting down Allegro would automatically destroy the
    # display, too.
    LibAllegro.destroy_display(display)
  end
end

ExFsResize.new.main
