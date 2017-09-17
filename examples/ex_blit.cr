# Crystal port of ex_blit.c from the Allegro examples.

# An example demonstrating different blending modes.

require "../src/crystal_allegro"
require "./common"

class ExBlit
  include Common

  class Example
    property! pattern : LibAllegro::Bitmap?
    property! font : LibAllegro::Font?
    property! queue : LibAllegro::EventQueue?
    property! background : LibAllegro::Color?
    property! text : LibAllegro::Color?
    property! white : LibAllegro::Color?

    property timer = Array(Float64).new(4, 0.0)
    property counter = Array(Float64).new(4, 0.0)
    property! fps : Int32?
    property! text_x : Float64?
    property! text_y : Float64?
  end

  property ex = Example.new

  def example_bitmap(w, h)
    mx = w * 0.5
    my = h * 0.5
    state = uninitialized LibAllegro::State
    pattern = LibAllegro.create_bitmap(w, h)
    LibAllegro.store_state(pointerof(state), LibAllegro::StateTargetBitmap)
    LibAllegro.set_target_bitmap(pattern)
    LibAllegro.lock_bitmap(pattern, LibAllegro::PixelFormatAny, LibAllegro::LockWriteonly)
    w.times do |i|
      h.times do |j|
        a = Math.atan2(i - mx, j - my)
        d = Math.sqrt((i - mx)**2 + (j - my)**2)
        sat = (1.0 - 1 / (1 + d * 0.1))**5
        hue = 3 * a * 180 / LibAllegro::PI
        hue = (hue / 360 - (hue / 360).floor) * 360
        LibAllegro.put_pixel(i, j, LibAllegro.color_hsv(hue, sat, 1))
      end
    end
    LibAllegro.put_pixel(0, 0, LibAllegro.map_rgb(0, 0, 0))
    LibAllegro.unlock_bitmap(pattern)
    LibAllegro.restore_state(pointerof(state))
    pattern
  end

  def set_xy(x, y)
    ex.text_x = x
    ex.text_y = y
  end

  def get_xy(x : Float64*, y : Float64*)
    x.value = ex.text_x
    y.value = ex.text_y
  end

  def print(format, *args)
    th = LibAllegro.get_font_line_height(ex.font)
    message = (format % args)[0, 1023]
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
    LibAllegro.draw_textf(ex.font, ex.text, ex.text_x, ex.text_y, 0, "%s", message)
    ex.text_y += th
  end

  def start_timer(i)
    ex.timer[i] -= LibAllegro.get_time
    ex.counter[i] += 1
  end

  def stop_timer(i)
    ex.timer[i] += LibAllegro.get_time
  end

  def get_fps(i)
    return 0.0 if ex.timer[i] == 0.0
    ex.counter[i] / ex.timer[i]
  end

  def draw
    x = y = 0.0
    iw = LibAllegro.get_bitmap_width(ex.pattern)
    ih = LibAllegro.get_bitmap_height(ex.pattern)

    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)

    LibAllegro.clear_to_color(ex.background)

    screen = LibAllegro.get_target_bitmap

    set_xy(8.0, 8.0)

    # Test 1.
    # Disabled: drawing to same bitmap is not supported.
    #
    # print("Screen -> Screen (%.1f fps)", get_fps(0))
    # get_xy(pointerof(x), pointerof(y))
    # LibAllegro.draw_bitmap(ex.pattern, x, y, 0)
    #
    # start_timer(0)
    # LibAllegro.draw_bitmap_region(screen, x, y, iw, ih, x + 8 + iw, y, 0)
    # stop_timer(0)
    # set_xy(x, y + ih)

    # Test 2.
    print("Screen -> Bitmap -> Screen (%.1f fps)", get_fps(1))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    temp = LibAllegro.create_bitmap(iw, ih)
    LibAllegro.set_target_bitmap(temp)
    LibAllegro.clear_to_color(LibAllegro.map_rgba_f(1, 0, 0, 1))
    start_timer(1)
    LibAllegro.draw_bitmap_region(screen, x, y, iw, ih, 0, 0, 0)

    LibAllegro.set_target_bitmap(screen)
    LibAllegro.draw_bitmap(temp, x + 8 + iw, y, 0)
    stop_timer(1)
    set_xy(x, y + ih)

    LibAllegro.destroy_bitmap(temp)

    # Test 3.
    print("Screen -> Memory -> Screen (%.1f fps)", get_fps(2))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)
    temp = LibAllegro.create_bitmap(iw, ih)
    LibAllegro.set_target_bitmap(temp)
    LibAllegro.clear_to_color(LibAllegro.map_rgba_f(1, 0, 0, 1))
    start_timer(2)
    LibAllegro.draw_bitmap_region(screen, x, y, iw, ih, 0, 0, 0)

    LibAllegro.set_target_bitmap(screen)
    LibAllegro.draw_bitmap(temp, x + 8 + iw, y, 0)
    stop_timer(2)
    set_xy(x, y + ih)

    LibAllegro.destroy_bitmap(temp)
    LibAllegro.set_new_bitmap_flags(LibAllegro::VideoBitmap)

    # Test 4.
    print("Screen -> Locked -> Screen (%.1f fps)", get_fps(3))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    start_timer(3)
    lock = LibAllegro.lock_bitmap_region(screen, x, y, iw, ih,
      LibAllegro::PixelFormatAny, LibAllegro::LockReadonly)
    format = lock.value.format
    size = lock.value.pixel_size
    data = Pointer(Void).malloc(size * iw * ih)
    ih.times do |i|
      (data.as(Pointer(UInt8)) + i * size * iw).copy_from(
        lock.value.data.as(Pointer(UInt8)) + i * lock.value.pitch, size * iw
      )
    end
    LibAllegro.unlock_bitmap(screen)

    lock = LibAllegro.lock_bitmap_region(screen, x + 8 + iw, y, iw, ih, format,
      LibAllegro::LockWriteonly)
    ih.times do |i|
      (lock.value.data.as(Pointer(UInt8)) + i * lock.value.pitch).copy_from(
        data.as(Pointer(UInt8)) + i * size * iw, size * iw
      )
    end
    LibAllegro.unlock_bitmap(screen)
    stop_timer(3)
    set_xy(x, y + ih)
  end

  def tick
    draw
    LibAllegro.flip_display
  end

  def run
    event = uninitialized LibAllegro::Event
    need_draw = true

    loop do
      if need_draw && LibAllegro.is_event_queue_empty(ex.queue) != 0
        tick
        need_draw = false
      end

      LibAllegro.wait_for_event(ex.queue, pointerof(event))

      case event.type
      when LibAllegro::EventDisplayClose
        return
      when LibAllegro::EventKeyDown
        return if event.keyboard.keycode == LibAllegro::KeyEscape
      when LibAllegro::EventTimer
        need_draw = true
      end
    end
  end

  def init
    ex.fps = 60

    font = ex.font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
    abort_example("data/fixed_font.tga not found\n") unless font
    ex.background = LibAllegro.color_name("beige")
    ex.text = LibAllegro.color_name("black")
    ex.white = LibAllegro.color_name("white")
    ex.pattern = example_bitmap(100, 100)
  end

  def main
    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    LibAllegro.install_keyboard
    LibAllegro.install_mouse
    LibAllegro.init_image_addon
    LibAllegro.init_font_addon
    init_platform_specific

    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    init

    timer = LibAllegro.create_timer(1.0 / ex.fps)

    ex.queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(ex.queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(ex.queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(ex.queue, LibAllegro.get_display_event_source(display))
    LibAllegro.register_event_source(ex.queue, LibAllegro.get_timer_event_source(timer))

    LibAllegro.start_timer(timer)
    run

    LibAllegro.destroy_event_queue(ex.queue)
  end
end

ExBlit.new.main
