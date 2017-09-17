# Crystal port of ex_clip.c from the Allegro examples.

# Test performance of LibAllegro.draw_bitmap_region, LibAllegro.create_sub_bitmap and
# LibAllegro.set_clipping_rectangle when clipping a bitmap.

require "../src/crystal_allegro"
require "./common"

class ExClip
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
        l = 1 - (1.0 - 1 / (1 + d * 0.1))**5
        hue = a * 180 / LibAllegro::PI
        sat = 1.0
        if i == 0 || j == 0 || i == w - 1 || j == h - 1
          hue += 180
        elsif i == 1 || j == 1 || i == w - 2 || j == h - 2
          hue += 180
          sat = 0.5
        end
        LibAllegro.put_pixel(i, j, LibAllegro.color_hsl(hue, sat, l))
      end
    end
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
    cx = cy = cw = ch = gap = 8

    LibAllegro.get_clipping_rectangle(pointerof(cx), pointerof(cy), pointerof(cw), pointerof(ch))

    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)

    LibAllegro.clear_to_color(ex.background)

    # Test 1.
    set_xy(8.0, 8.0)
    print("LibAllegro.draw_bitmap_region (%.1f fps)", get_fps(0))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    start_timer(0)
    LibAllegro.draw_bitmap_region(ex.pattern, 1, 1, iw - 2, ih - 2,
      x + 8 + iw + 1, y + 1, 0)
    stop_timer(0)
    set_xy(x, y + ih + gap)

    # Test 2.
    print("LibAllegro.create_sub_bitmap (%.1f fps)", get_fps(1))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    start_timer(1)
    temp = LibAllegro.create_sub_bitmap(ex.pattern, 1, 1, iw - 2, ih - 2)
    LibAllegro.draw_bitmap(temp, x + 8 + iw + 1, y + 1, 0)
    LibAllegro.destroy_bitmap(temp)
    stop_timer(1)
    set_xy(x, y + ih + gap)

    # Test 3.
    print("LibAllegro.set_clipping_rectangle (%.1f fps)", get_fps(2))
    get_xy(pointerof(x), pointerof(y))
    LibAllegro.draw_bitmap(ex.pattern, x, y, 0)

    start_timer(2)
    LibAllegro.set_clipping_rectangle(x + 8 + iw + 1, y + 1, iw - 2, ih - 2)
    LibAllegro.draw_bitmap(ex.pattern, x + 8 + iw, y, 0)
    LibAllegro.set_clipping_rectangle(cx, cy, cw, ch)
    stop_timer(2)
    set_xy(x, y + ih + gap)
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

    font = ex.font = LibAllegro.create_builtin_font
    abort_example("Error creating builtin font.\n") unless font
    ex.background = LibAllegro.color_name("beige")
    ex.text = LibAllegro.color_name("blue")
    ex.white = LibAllegro.color_name("white")
    ex.pattern = example_bitmap(100, 100)
  end

  def main
    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    LibAllegro.install_keyboard
    LibAllegro.install_mouse
    LibAllegro.init_font_addon
    init_platform_specific

    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display.\n") unless display

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

ExClip.new.main
