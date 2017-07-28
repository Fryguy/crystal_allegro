# Crystal port of ex_bitmap_flip.c from the Allegro examples.

# An example showing bitmap flipping flags, by Steven Wallace.

require "../src/crystal_allegro"
require "./common"

class ExBitmapFlip
  include Common

  # Fire the update every 10 milliseconds.
  INTERVAL = 0.01

  @bmp_x = 200.0
  @bmp_y = 200.0
  @bmp_dx = 96.0
  @bmp_dy = 96.0
  @bmp_flag = 0

  # Updates the bitmap velocity, orientation and position.
  def update(bmp)
    target = LibAllegro.get_target_bitmap
    display_w = LibAllegro.get_bitmap_width(target)
    display_h = LibAllegro.get_bitmap_height(target)
    bitmap_w = LibAllegro.get_bitmap_width(bmp)
    bitmap_h = LibAllegro.get_bitmap_height(bmp)

    @bmp_x += @bmp_dx * INTERVAL
    @bmp_y += @bmp_dy * INTERVAL

    # Make sure bitmap is still on the screen.
    if @bmp_y < 0
      @bmp_y = 0
      @bmp_dy *= -1
      @bmp_flag &= ~LibAllegro::FlipVertical
    end

    if @bmp_x < 0
      @bmp_x = 0
      @bmp_dx *= -1
      @bmp_flag &= ~LibAllegro::FlipHorizontal
    end

    if @bmp_y > display_h - bitmap_h
      @bmp_y = display_h - bitmap_h
      @bmp_dy *= -1
      @bmp_flag |= LibAllegro::FlipVertical
    end

    if @bmp_x > display_w - bitmap_w
      @bmp_x = display_w - bitmap_w
      @bmp_dx *= -1
      @bmp_flag |= LibAllegro::FlipHorizontal
    end
  end

  def main
    done = false
    redraw = true

    abort_example("Failed to init Allegro.\n") unless CrystalAllegro.init

    # Initialize the image addon. Requires the allegro_image addon
    # library.
    abort_example("Failed to init IIO addon.\n") unless LibAllegro.init_image_addon

    # Initialize the image font. Requires the allegro_font addon
    # library.
    LibAllegro.init_font_addon
    init_platform_specific # Helper functions from common.c.

    # Create a new display that we can render the image to.
    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display.\n") unless display

    # Allegro requires installing drivers for all input devices before
    # they can be used.
    abort_example("Error installing keyboard.\n") unless LibAllegro.install_keyboard

    # Loads a font from disk. This will use LibAllegro.load_bitmap_font if you
    # pass the name of a known bitmap format, or else LibAllegro.load_ttf_font.
    font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
    abort_example("Error loading data/fixed_font.tga\n") unless font

    bmp = disp_bmp = LibAllegro.load_bitmap("data/mysha.pcx")
    abort_example("Error loading data/mysha.pcx\n") unless bmp
    text = "Display bitmap (space to change)"

    LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)
    mem_bmp = LibAllegro.load_bitmap("data/mysha.pcx")
    abort_example("Error loading data/mysha.pcx\n") unless mem_bmp

    timer = LibAllegro.create_timer(INTERVAL)

    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))

    LibAllegro.start_timer(timer)

    # Default premultiplied aplha blending.
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)

    # Primary 'game' loop.
    event = LibAllegro::Event.new
    until done
      # If the timer has since been fired and the queue is empty, draw.
      if redraw && LibAllegro.is_event_queue_empty(queue)
        update(bmp)
        # Clear so we don't get trippy artifacts left after zoom.
        LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))
        LibAllegro.draw_tinted_bitmap(bmp, LibAllegro.map_rgba_f(1, 1, 1, 0.5),
          @bmp_x, @bmp_y, @bmp_flag)
        LibAllegro.draw_text(font, LibAllegro.map_rgba_f(1, 1, 1, 0.5), 0, 0, 0, text)
        LibAllegro.flip_display
        redraw = false
      end

      LibAllegro.wait_for_event(queue, pointerof(event))
      case event.type
      when LibAllegro::EventKeyDown
        if event.keyboard.keycode == LibAllegro::KeyEscape
          done = true
        elsif event.keyboard.keycode == LibAllegro::KeySpace
          # Spacebar toggles whether render from a memory bitmap
          # or display bitamp.
          if bmp == mem_bmp
            bmp = disp_bmp
            text = "Display bitmap (space to change)"
          else
            bmp = mem_bmp
            text = "Memory bitmap (space to change)"
          end
        end
      when LibAllegro::EventDisplayClose
        done = true
      when LibAllegro::EventTimer
        redraw = true
      end
    end

    LibAllegro.destroy_bitmap(bmp)
  end
end

CrystalAllegro.run_main { ExBitmapFlip.new.main }
