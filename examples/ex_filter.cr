# Crystal port of ex_filter.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExFilter
  include Common

  FPS = 60

  class Example
    property! display : Pointer(LibAllegro::Display)?
    property! font : LibAllegro::Font?
    property bitmaps = Array(Array(LibAllegro::Bitmap)).new(2) { Array(LibAllegro::Bitmap).new(9) { Pointer(Void).null.as(LibAllegro::Bitmap) } }
    property! bg : LibAllegro::Color?
    property! fg : LibAllegro::Color?
    property! info : LibAllegro::Color?
    property bitmap = 0
    property ticks = 0
  end

  property example = Example.new

  FILTER_FLAGS = [
    0,
    LibAllegro::MinLinear,
    LibAllegro::Mipmap,
    LibAllegro::MinLinear | LibAllegro::Mipmap,
    0,
    LibAllegro::MagLinear,
  ]

  FILTER_TEXT = [
    "nearest", "linear",
    "nearest mipmap", "linear mipmap",
  ]

  def update
    example.ticks += 1
  end

  def redraw
    w = LibAllegro.get_display_width(example.display)
    h = LibAllegro.get_display_height(example.display)

    LibAllegro.clear_to_color(example.bg)

    6.times do |i|
      x = ((i / 2) * w / 3 + w / 6).to_f
      y = ((i % 2) * h / 2 + h / 4).to_f
      bmp = example.bitmaps[example.bitmap][i]
      bw = LibAllegro.get_bitmap_width(bmp).to_f
      bh = LibAllegro.get_bitmap_height(bmp).to_f
      t = 1 - 2 * ((example.ticks % (FPS * 16)) / 16.0 / FPS - 0.5).abs
      angle = example.ticks * LibAllegro::PI * 2 / FPS / 8

      if (i < 4)
        scale = 1 - t * 0.9
      else
        scale = 1 + t * 9
      end

      LibAllegro.draw_textf(example.font, example.fg, x, y - 64 - 14,
        LibAllegro::AlignCentre, "%s", FILTER_TEXT[i % 4])

      LibAllegro.set_clipping_rectangle(x - 64, y - 64, 128, 128)
      LibAllegro.draw_scaled_rotated_bitmap(bmp, bw / 2, bh / 2,
        x, y, scale, scale, angle, 0)
      LibAllegro.set_clipping_rectangle(0, 0, w, h)
    end
    LibAllegro.draw_textf(example.font, example.info, w / 2, h - 14,
      LibAllegro::AlignCentre, "press space to change")
  end

  def main
    w = 640
    h = 480
    done = false
    need_redraw = true

    abort_example("Failed to init Allegro.\n") unless CrystalAllegro.init

    abort_example("Failed to init IIO addon.\n") unless LibAllegro.init_image_addon

    LibAllegro.init_font_addon

    init_platform_specific

    display = example.display = LibAllegro.create_display(w, h)

    abort_example("Error creating display.\n") unless display

    abort_example("Error installing keyboard.\n") unless LibAllegro.install_keyboard

    abort_example("Error installing mouse.\n") unless LibAllegro.install_mouse

    font = example.font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
    abort_example("Error loading data/fixed_font.tga\n") unless font

    mysha = LibAllegro.load_bitmap("data/mysha256x256.png")
    abort_example("Error loading data/mysha256x256.png\n") unless mysha

    6.times do |i|
      # Only power-of-two bitmaps can have mipmaps.
      LibAllegro.set_new_bitmap_flags(FILTER_FLAGS[i])
      example.bitmaps[0][i] = LibAllegro.create_bitmap(1024, 1024)
      example.bitmaps[1][i] = LibAllegro.clone_bitmap(mysha)
      lock = LibAllegro.lock_bitmap(example.bitmaps[0][i],
        LibAllegro::PixelFormatAbgr8888Le, LibAllegro::LockWriteonly)
      1024.times do |y|
        row = lock.value.data.as(Pointer(UInt8)) + lock.value.pitch * y
        ptr = row
        chars = 1024.times do |x|
          c = 0u8
          c = 255u8 if (((x >> 2) & 1) ^ ((y >> 2) & 1)) != 0
          ptr[0] = c
          ptr += 1
          ptr[0] = c
          ptr += 1
          ptr[0] = c
          ptr += 1
          ptr[0] = 255u8
          ptr += 1
        end
      end
      LibAllegro.unlock_bitmap(example.bitmaps[0][i])
    end

    example.bg = LibAllegro.map_rgb_f(0, 0, 0)
    example.fg = LibAllegro.map_rgb_f(1, 1, 1)
    example.info = LibAllegro.map_rgb_f(0.5, 0.5, 1)

    timer = LibAllegro.create_timer(1.0 / FPS)

    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(example.display))

    LibAllegro.start_timer(timer)

    event = uninitialized LibAllegro::Event
    until done
      if need_redraw && LibAllegro.is_event_queue_empty(queue)
        redraw
        LibAllegro.flip_display
        need_redraw = false
      end

      LibAllegro.wait_for_event(queue, pointerof(event))
      case event.type
      when LibAllegro::EventKeyDown
        case event.keyboard.keycode
        when LibAllegro::KeyEscape
          done = true
        when LibAllegro::KeySpace
          example.bitmap = (example.bitmap + 1) % 2
        end
      when LibAllegro::EventDisplayClose
        done = true
      when LibAllegro::EventTimer
        update
        need_redraw = true
      when LibAllegro::EventMouseButtonDown
        example.bitmap = (example.bitmap + 1) % 2
      end
    end

    6.times do |i|
      LibAllegro.destroy_bitmap(example.bitmaps[0][i])
      LibAllegro.destroy_bitmap(example.bitmaps[1][i])
    end
  end
end

ExFilter.new.main
