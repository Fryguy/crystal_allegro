# Crystal port of ex_bitmap.c from the Allegro examples.
#
# This example displays a picture on the screen, with support for
# command-line parameters, multi-screen, screen-orientation and
# zooming.

require "../src/crystal_allegro"
require "./common"

class ExBitmap
  include Common

  def main(argc, argv)
    redraw = true
    zoom = 1.0

    # The first commandline argument can optionally specify an
    # image to display instead of the default. Allegro's image
    # addon suports BMP, DDS, PCX, TGA and can be compiled with
    # PNG and JPG support on all platforms. Additional formats
    # are supported by platform specific libraries and support for
    # image formats can also be added at runtime.
    filename = argc > 1 ? argv[1] : "data/mysha.pcx"

    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    # Initializes and displays a log window for debugging purposes.
    open_log

    # The second parameter to the process can optionally specify what
    # adapter to use.
    LibAllegro.set_new_display_adapter(argv[2].to_i) if argc > 2

    # Allegro requires installing drivers for all input devices before
    # they can be used.
    LibAllegro.install_mouse
    LibAllegro.install_keyboard

    # Initialize the image addon. Requires the allegro_image addon
    # library.
    LibAllegro.init_image_addon

    # Helper functions from common.cr.
    init_platform_specific

    # Create a new display that we can render the image to.
    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    LibAllegro.set_window_title(display, filename)

    # Load the image and time how long it took for the log.
    t0 = LibAllegro.get_time
    bitmap = LibAllegro.load_bitmap(filename)
    t1 = LibAllegro.get_time
    abort_example("%s not found or failed to load\n", filename) unless bitmap

    log_printf("Loading took %.4f seconds\n", t1 - t0)

    # Create a timer that fires 30 times a second.
    timer = LibAllegro.create_timer(1.0 / 30)
    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
    LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
    LibAllegro.start_timer(timer) # Start the timer

    # Primary 'game' loop.
    event = LibAllegro::Event.new
    loop do
      LibAllegro.wait_for_event(queue, pointerof(event)) # Wait for and get an event.
      case event.type
      when LibAllegro::EventDisplayOrientation
        o = event.display.orientation
        case o
        when LibAllegro::DisplayOrientation0Degrees   then log_printf("0 degrees\n")
        when LibAllegro::DisplayOrientation90Degrees  then log_printf("90 degrees\n")
        when LibAllegro::DisplayOrientation180Degrees then log_printf("180 degrees\n")
        when LibAllegro::DisplayOrientation270Degrees then log_printf("270 degrees\n")
        when LibAllegro::DisplayOrientationFaceUp     then log_printf("Face up\n")
        when LibAllegro::DisplayOrientationFaceDown   then log_printf("Face down\n")
        end
      when LibAllegro::EventDisplayClose
        break
      when LibAllegro::EventKeyChar
        # Use keyboard to zoom image in and out.
        # 1: Reset zoom.
        # +: Zoom in 10%
        # -: Zoom out 10%
        # f: Zoom to width of window
        break if event.keyboard.keycode == LibAllegro::KeyEscape # Break the loop and quite on escape key.
        case event.keyboard.unichar
        when '1' then zoom = 1.0
        when '+' then zoom *= 1.1
        when '-' then zoom /= 1.1
        when 'f' then zoom = LibAllegro.get_display_width(display).to_f / LibAllegro.get_bitmap_width(bitmap)
        end
      when LibAllegro::EventTimer
        # Trigger a redraw on the timer event
        redraw = true
      end

      # Redraw, but only if the event queue is empty
      if redraw && LibAllegro.is_event_queue_empty(queue)
        redraw = false
        # Clear so we don't get trippy artifacts left after zoom.
        LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))
        if zoom == 1
          LibAllegro.draw_bitmap(bitmap, 0, 0, 0)
        else
          LibAllegro.draw_scaled_rotated_bitmap(bitmap,
            0, 0, 0, 0, zoom, zoom, 0, 0)
        end
        LibAllegro.flip_display
      end
    end

    LibAllegro.destroy_bitmap(bitmap)

    close_log(false)
  end
end

ex = ExBitmap.new
CrystalAllegro.run_main(->ex.main(Int32, Array(String)))
