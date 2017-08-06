# Crystal port of ex_blend.c from the Allegro examples.

# An example demonstrating different blending modes.

require "../src/crystal_allegro"
require "./common"

class ExBlend
  include Common

  # A structure holding all variables of our example program.
  class Example
    property! example : LibAllegro::Bitmap?   # Our example bitmap.
    property! offscreen : LibAllegro::Bitmap? # An offscreen buffer, for testing.
    property! memory : LibAllegro::Bitmap?    # A memory buffer, for testing.
    property! myfont : LibAllegro::Font?      # Our font.
    property! queue : LibAllegro::EventQueue? # Our events queue.
    property image : Int32 = 0                # Which test image to use.
    property mode : Int32 = 0                 # How to draw it.
    property buttons_x : Int32 = 0            # Where to draw buttons.
    property max_fps : Int32 = 0
    property last_second : Float64 = 0.0
    property frames_accum : Int32 = 0
    property fps : Float64 = 0.0
  end

  @ex = Example.new

  # Print some text with a shadow.
  def print(x, y, vertical, format, *args)
    message = format % args

    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
    h = LibAllegro.get_font_line_height(@ex.myfont)

    2.times do |j|
      color =
        if j == 0
          LibAllegro.map_rgb(0, 0, 0)
        else
          LibAllegro.map_rgb(255, 255, 255)
        end

      if vertical
        ui = uninitialized LibAllegro::UstrInfo
        us = LibAllegro.ref_cstr(pointerof(ui), message)
        letter = uninitialized LibAllegro::UstrInfo
        LibAllegro.ustr_length(us).times do |i|
          LibAllegro.draw_ustr(@ex.myfont, color, x + 1 - j, y + 1 - j + h * i, 0,
            LibAllegro.ref_ustr(pointerof(letter), us, LibAllegro.ustr_offset(us, i),
              LibAllegro.ustr_offset(us, i + 1)))
        end
      else
        LibAllegro.draw_text(@ex.myfont, color, x + 1 - j, y + 1 - j, 0, message)
      end
    end
  end

  # Create an example bitmap.
  def create_example_bitmap
    bitmap = LibAllegro.create_bitmap(100, 100)
    locked = LibAllegro.lock_bitmap(bitmap, LibAllegro::PixelFormatAbgr8888, LibAllegro::LockWriteonly)
    data = locked.value.data.as(Pointer(UInt8))

    100.times do |j|
      100.times do |i|
        x = i - 50
        y = j - 50
        r = Math.sqrt(x * x + y * y)
        rc = 1 - r / 50.0
        rc = 0.0 if rc < 0
        data[i * 4 + 0] = (i * 255 / 100).to_u8
        data[i * 4 + 1] = (j * 255 / 100).to_u8
        data[i * 4 + 2] = (rc * 255).to_u8
        data[i * 4 + 3] = (rc * 255).to_u8
      end
      data += locked.value.pitch
    end
    LibAllegro.unlock_bitmap(bitmap)

    bitmap
  end

  # Draw our example scene.
  def draw
    test = [] of LibAllegro::Color
    target = LibAllegro.get_target_bitmap

    blend_names = %w(ZERO ONE ALPHA INVERSE)
    blend_vnames = %w(ZERO ONE ALPHA INVER)
    blend_modes = [LibAllegro::Zero, LibAllegro::One, LibAllegro::Alpha,
                   LibAllegro::InverseAlpha]
    x = 40.0
    y = 40.0

    LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0.5, 0.5, 0.5))

    test << LibAllegro.map_rgba_f(1, 1, 1, 1)
    test << LibAllegro.map_rgba_f(1, 1, 1, 0.5)
    test << LibAllegro.map_rgba_f(1, 1, 1, 0.25)
    test << LibAllegro.map_rgba_f(1, 0, 0, 0.75)
    test << LibAllegro.map_rgba_f(0, 0, 0, 0)

    print(x, 0, false, "D  E  S  T  I  N  A  T  I  O  N  (%0.2f fps)", @ex.fps)
    print(0, y, true, "S O U R C E")
    4.times do |i|
      print(x + i * 110, 20, false, blend_names[i])
      print(20, y + i * 110, true, blend_vnames[i])
    end

    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    if @ex.mode >= 1 && @ex.mode <= 5
      LibAllegro.set_target_bitmap(@ex.offscreen)
      LibAllegro.clear_to_color(test[@ex.mode - 1])
    end
    if @ex.mode >= 6 && @ex.mode <= 10
      LibAllegro.set_target_bitmap(@ex.memory)
      LibAllegro.clear_to_color(test[@ex.mode - 6])
    end

    4.times do |j|
      4.times do |i|
        LibAllegro.set_blender(LibAllegro::Add, blend_modes[j], blend_modes[i])
        if @ex.image == 0
          LibAllegro.draw_bitmap(@ex.example, x + i * 110, y + j * 110, 0)
        elsif @ex.image >= 1 && @ex.image <= 6
          LibAllegro.draw_filled_rectangle(x + i * 110, y + j * 110,
            x + i * 110 + 100, y + j * 110 + 100,
            test[@ex.image - 1])
        end
      end
    end

    if @ex.mode >= 1 && @ex.mode <= 5
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      LibAllegro.set_target_bitmap(target)
      LibAllegro.draw_bitmap_region(@ex.offscreen, x, y, 430, 430, x, y, 0)
    end
    if @ex.mode >= 6 && @ex.mode <= 10
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      LibAllegro.set_target_bitmap(target)
      LibAllegro.draw_bitmap_region(@ex.memory, x, y, 430, 430, x, y, 0)
    end

    is = ->(n : Int32) { @ex.image == n ? "*" : " " }
    print(@ex.buttons_x, 20 * 1, false, "What to draw")
    print(@ex.buttons_x, 20 * 2, false, "%s Picture", is.call(0))
    print(@ex.buttons_x, 20 * 3, false, "%s Rec1 (1/1/1/1)", is.call(1))
    print(@ex.buttons_x, 20 * 4, false, "%s Rec2 (1/1/1/.5)", is.call(2))
    print(@ex.buttons_x, 20 * 5, false, "%s Rec3 (1/1/1/.25)", is.call(3))
    print(@ex.buttons_x, 20 * 6, false, "%s Rec4 (1/0/0/.75)", is.call(4))
    print(@ex.buttons_x, 20 * 7, false, "%s Rec5 (0/0/0/0)", is.call(5))

    is = ->(n : Int32) { @ex.mode == n ? "*" : " " }
    print(@ex.buttons_x, 20 * 9, false, "Where to draw")
    print(@ex.buttons_x, 20 * 10, false, "%s screen", is.call(0))

    print(@ex.buttons_x, 20 * 11, false, "%s offscreen1", is.call(1))
    print(@ex.buttons_x, 20 * 12, false, "%s offscreen2", is.call(2))
    print(@ex.buttons_x, 20 * 13, false, "%s offscreen3", is.call(3))
    print(@ex.buttons_x, 20 * 14, false, "%s offscreen4", is.call(4))
    print(@ex.buttons_x, 20 * 15, false, "%s offscreen5", is.call(5))

    print(@ex.buttons_x, 20 * 16, false, "%s memory1", is.call(6))
    print(@ex.buttons_x, 20 * 17, false, "%s memory2", is.call(7))
    print(@ex.buttons_x, 20 * 18, false, "%s memory3", is.call(8))
    print(@ex.buttons_x, 20 * 19, false, "%s memory4", is.call(9))
    print(@ex.buttons_x, 20 * 20, false, "%s memory5", is.call(10))
  end

  # Called a fixed amount of times per second.
  def tick
    # Count frames during the last second or so.
    t = LibAllegro.get_time
    if t >= @ex.last_second + 1
      @ex.fps = @ex.frames_accum / (t - @ex.last_second)
      @ex.frames_accum = 0
      @ex.last_second = t
    end

    draw
    LibAllegro.flip_display
    @ex.frames_accum += 1
  end

  # Run our test.
  def run
    event = LibAllegro::Event.new
    need_draw = true

    loop do
      # Perform frame skipping so we don't fall behind the timer events.
      if need_draw && LibAllegro.is_event_queue_empty(@ex.queue)
        tick
        need_draw = false
      end

      LibAllegro.wait_for_event(@ex.queue, pointerof(event))

      case event.type
      when LibAllegro::EventDisplayClose
        # Was the X button on the window pressed?
        return
      when LibAllegro::EventKeyDown
        # Was a key pressed?
        return if event.keyboard.keycode == LibAllegro::KeyEscape
      when LibAllegro::EventTimer
        # Is it time for the next timer tick?
        need_draw = true
      when LibAllegro::EventMouseButtonUp
        # Mouse click?
        x = event.mouse.x
        y = event.mouse.y
        if x >= @ex.buttons_x
          button = y / 20
          @ex.image = 0 if button == 2
          @ex.image = 1 if button == 3
          @ex.image = 2 if button == 4
          @ex.image = 3 if button == 5
          @ex.image = 4 if button == 6
          @ex.image = 5 if button == 7

          @ex.mode = 0 if button == 10

          @ex.mode = 1 if button == 11
          @ex.mode = 2 if button == 12
          @ex.mode = 3 if button == 13
          @ex.mode = 4 if button == 14
          @ex.mode = 5 if button == 15

          @ex.mode = 6 if button == 16
          @ex.mode = 7 if button == 17
          @ex.mode = 8 if button == 18
          @ex.mode = 9 if button == 19
          @ex.mode = 10 if button == 20
        end
      end
    end
  end

  # Initialize the example.
  def init
    @ex.buttons_x = 40 + 110 * 4
    @ex.max_fps = 60

    myfont = @ex.myfont = LibAllegro.load_font("data/font.tga", 0, 0)
    abort_example("data/font.tga not found\n") unless myfont
    @ex.example = create_example_bitmap

    @ex.offscreen = LibAllegro.create_bitmap(640, 480)
    LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)
    @ex.memory = LibAllegro.create_bitmap(640, 480)
  end

  def main
    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    LibAllegro.init_primitives_addon
    LibAllegro.install_keyboard
    LibAllegro.install_mouse
    LibAllegro.install_touch_input
    LibAllegro.init_image_addon
    LibAllegro.init_font_addon
    init_platform_specific

    display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    init

    timer = LibAllegro.create_timer(1.0 / @ex.max_fps)

    queue = @ex.queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
    LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
    # if LibAllegro.is_touch_input_installed
    #   LibAllegro.register_event_source(@ex.queue,
    #     LibAllegro.get_touch_input_mouse_emulation_event_source)
    # end

    LibAllegro.start_timer(timer)
    run

    LibAllegro.destroy_event_queue(@ex.queue)
  end
end

ExBlend.new.main
