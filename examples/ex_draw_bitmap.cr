# Crystal port of ex_draw_bitmap.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExDrawBitmap
  include Common

  # ALLEGRO_DEBUG_CHANNEL("main")

  FPS         =   60
  MAX_SPRITES = 1024

  class Sprite
    property x = 0.0
    property y = 0.0
    property dx = 0.0
    property dy = 0.0
  end

  TEXT = [
    "H - toggle held drawing",
    "Space - toggle use of textures",
    "B - toggle alpha blending",
    "Left/Right - change bitmap size",
    "Up/Down - change bitmap count",
    "F1 - toggle help text",
  ]

  class Example
    property sprites = Array(ExDrawBitmap::Sprite).new(MAX_SPRITES) { ExDrawBitmap::Sprite.new }
    property use_memory_bitmaps = false
    property blending = 0
    property! display : Pointer(LibAllegro::Display)?
    property! mysha : LibAllegro::Bitmap?
    property! bitmap : LibAllegro::Bitmap?
    property hold_bitmap_drawing = false
    property bitmap_size = 0
    property sprite_count = 0
    property show_help = false
    property! font : LibAllegro::Font?

    property t = 0

    property! white : LibAllegro::Color?
    property! half_white : LibAllegro::Color?
    property! dark : LibAllegro::Color?
    property! red : LibAllegro::Color?

    property direct_speed_measure = 0.0

    property ftpos = 0
    property frame_times = Array(Float64).new(FPS, 0.0)

    def bitmap?
      !!@bitmap
    end
  end

  property example = Example.new

  def add_time
    example.frame_times[example.ftpos] = LibAllegro.get_time
    example.ftpos += 1
    example.ftpos = 0 if example.ftpos >= FPS
  end

  def get_fps(average : Int32*, minmax : Int32*)
    prev = FPS - 1
    min_dt = 1.0
    max_dt = 1 / 1000000.0
    av = 0.0
    FPS.times do |i|
      if i != example.ftpos
        dt = example.frame_times[i] - example.frame_times[prev]
        min_dt = dt if dt < min_dt
        max_dt = dt if dt > max_dt
        av += dt
      end
      prev = i
    end
    av /= (FPS - 1)
    average.value = (1 / av).ceil.to_i
    d = 1 / min_dt - 1 / max_dt
    minmax.value = (d / 2).floor.to_i
  end

  def add_sprite
    if example.sprite_count < MAX_SPRITES
      w = LibAllegro.get_display_width(example.display)
      h = LibAllegro.get_display_height(example.display)
      i = example.sprite_count
      example.sprite_count += 1
      s = example.sprites[i]
      a = rand(360).to_f
      s.x = rand(w - example.bitmap_size).to_f
      s.y = rand(h - example.bitmap_size).to_f
      s.dx = Math.cos(a) * FPS * 2
      s.dy = Math.sin(a) * FPS * 2
    end
  end

  def add_sprites(n)
    n.times { add_sprite }
  end

  def remove_sprites(n)
    example.sprite_count -= n
    example.sprite_count = 0 if example.sprite_count < 0
  end

  def change_size(size)
    size = 1 if size < 1
    size = 1024 if size > 1024

    LibAllegro.destroy_bitmap(example.bitmap) if example.bitmap?
    LibAllegro.set_new_bitmap_flags(
      example.use_memory_bitmaps ? LibAllegro::MemoryBitmap : LibAllegro::VideoBitmap)
    example.bitmap = LibAllegro.create_bitmap(size, size)
    example.bitmap_size = size
    LibAllegro.set_target_bitmap(example.bitmap)
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    LibAllegro.clear_to_color(LibAllegro.map_rgba_f(0, 0, 0, 0))
    bw = LibAllegro.get_bitmap_width(example.mysha)
    bh = LibAllegro.get_bitmap_height(example.mysha)
    LibAllegro.draw_scaled_bitmap(example.mysha, 0, 0, bw, bh, 0, 0,
      size, size, 0)
    LibAllegro.set_target_backbuffer(example.display)
  end

  def sprite_update(s)
    w = LibAllegro.get_display_width(example.display)
    h = LibAllegro.get_display_height(example.display)

    s.x += s.dx / FPS
    s.y += s.dy / FPS

    if s.x < 0
      s.x = -s.x
      s.dx = -s.dx
    end
    if s.x + example.bitmap_size > w
      s.x = -s.x + 2 * (w - example.bitmap_size)
      s.dx = -s.dx
    end
    if s.y < 0
      s.y = -s.y
      s.dy = -s.dy
    end
    if s.y + example.bitmap_size > h
      s.y = -s.y + 2 * (h - example.bitmap_size)
      s.dy = -s.dy
    end

    s.x = (w / 2 - example.bitmap_size / 2).to_f if example.bitmap_size > w
    s.y = (h / 2 - example.bitmap_size / 2).to_f if example.bitmap_size > h
  end

  def update
    example.sprite_count.times do |i|
      sprite_update(example.sprites[i])
    end

    example.t += 1
    if example.t == 60
      # ALLEGRO_DEBUG("tick")
      example.t = 0
    end
  end

  def redraw
    w = LibAllegro.get_display_width(example.display)
    h = LibAllegro.get_display_height(example.display)
    f1 = uninitialized Int32
    f2 = uninitialized Int32
    fh = LibAllegro.get_font_line_height(example.font)
    info = ["textures", "memory buffers"]
    binfo = ["alpha", "additive", "tinted", "solid"]
    tint = example.white

    case example.blending
    when 0
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      tint = example.half_white
    when 1
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::One)
      tint = example.dark
    when 2
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
      tint = example.red
    when 3
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    end

    LibAllegro.hold_bitmap_drawing(1) if example.hold_bitmap_drawing
    example.sprite_count.times do |i|
      s = example.sprites[i]
      LibAllegro.draw_tinted_bitmap(example.bitmap, tint, s.x, s.y, 0)
    end
    LibAllegro.hold_bitmap_drawing(0) if example.hold_bitmap_drawing

    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
    if example.show_help
      dh = (fh * 3.5).to_i
      5.downto(0).each do |i|
        LibAllegro.draw_text(example.font, example.white, 0, h - dh, 0, TEXT[i])
        dh += fh * 6
      end
    end

    LibAllegro.draw_textf(example.font, example.white, 0, 0, 0, "count: %d",
      example.sprite_count)
    LibAllegro.draw_textf(example.font, example.white, 0, fh, 0, "size: %d",
      example.bitmap_size)
    LibAllegro.draw_textf(example.font, example.white, 0, fh * 2, 0, "%s",
      info[example.use_memory_bitmaps ? 1 : 0])
    LibAllegro.draw_textf(example.font, example.white, 0, fh * 3, 0, "%s",
      binfo[example.blending])

    get_fps(pointerof(f1), pointerof(f2))
    LibAllegro.draw_textf(example.font, example.white, w, 0, LibAllegro::AlignRight, "FPS: %4d +- %-4d",
      f1, f2)
    LibAllegro.draw_textf(example.font, example.white, w, fh, LibAllegro::AlignRight, "%4d / sec",
      (1.0 / example.direct_speed_measure).to_i)
  end

  def main
    info = uninitialized LibAllegro::MonitorInfo
    w, h = 640, 480
    done = false
    need_redraw = true
    background = false
    example.show_help = true
    example.hold_bitmap_drawing = false

    abort_example("Failed to init Allegro.\n") unless CrystalAllegro.init

    abort_example("Failed to init IIO addon.\n") unless LibAllegro.init_image_addon

    LibAllegro.init_font_addon
    init_platform_specific

    LibAllegro.get_num_video_adapters

    LibAllegro.get_monitor_info(0, pointerof(info))
    LibAllegro.set_new_display_flags(LibAllegro::FullscreenWindow) if ENV["ALLEGRO_CFG_OPENGLES"]?
    LibAllegro.set_new_display_option(LibAllegro::SupportedOrientations,
      LibAllegro::DisplayOrientationAll, LibAllegro::Suggest)
    display = example.display = LibAllegro.create_display(w, h)
    abort_example("Error creating display.\n") unless display

    w = LibAllegro.get_display_width(example.display)
    h = LibAllegro.get_display_height(example.display)

    abort_example("Error installing keyboard.\n") unless LibAllegro.install_keyboard

    abort_example("Error installing mouse.\n") unless LibAllegro.install_mouse

    # LibAllegro.install_touch_input

    font = example.font = LibAllegro.create_builtin_font
    abort_example("Error creating builtin font\n") unless font

    mysha = example.mysha = LibAllegro.load_bitmap("data/mysha256x256.png")
    abort_example("Error loading data/mysha256x256.png\n") unless mysha

    example.white = LibAllegro.map_rgb_f(1, 1, 1)
    example.half_white = LibAllegro.map_rgba_f(1, 1, 1, 0.5)
    example.dark = LibAllegro.map_rgb(15, 15, 15)
    example.red = LibAllegro.map_rgb_f(1, 0.2, 0.1)
    change_size(256)
    add_sprite
    add_sprite

    timer = LibAllegro.create_timer(1.0 / FPS)

    queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))

    # if LibAllegro.install_touch_input
    #   LibAllegro.register_event_source(queue, LibAllegro.get_touch_input_event_source)
    # end
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(example.display))

    LibAllegro.start_timer(timer)

    event = uninitialized LibAllegro::Event
    until done
      w = LibAllegro.get_display_width(example.display)
      h = LibAllegro.get_display_height(example.display)

      if !background && need_redraw && LibAllegro.is_event_queue_empty(queue)
        t = -LibAllegro.get_time
        add_time
        LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))
        redraw
        t += LibAllegro.get_time
        example.direct_speed_measure = t
        LibAllegro.flip_display
        need_redraw = false
      end

      LibAllegro.wait_for_event(queue, pointerof(event))
      case event.type
      when LibAllegro::EventKeyChar # includes repeats
        case event.keyboard.keycode
        when LibAllegro::KeyEscape
          done = true
        when LibAllegro::KeyUp
          add_sprites(1)
        when LibAllegro::KeyDown
          remove_sprites(1)
        when LibAllegro::KeyLeft
          change_size(example.bitmap_size - 1)
        when LibAllegro::KeyRight
          change_size(example.bitmap_size + 1)
        when LibAllegro::KeyF1
          example.show_help ^= true
        when LibAllegro::KeySpace
          example.use_memory_bitmaps ^= true
          change_size(example.bitmap_size)
        when LibAllegro::KeyB
          example.blending += 1
          example.blending = 0 if example.blending == 4
        end
      when LibAllegro::EventDisplayClose
        done = true
      when LibAllegro::EventDisplayHaltDrawing
        background = true
        LibAllegro.acknowledge_drawing_halt(event.display.source)
      when LibAllegro::EventDisplayResumeDrawing
        background = false
        LibAllegro.acknowledge_drawing_resume(event.display.source)
      when LibAllegro::EventDisplayResize
        LibAllegro.acknowledge_resize(event.display.source)
      when LibAllegro::EventTimer
        update
        need_redraw = true
      when LibAllegro::EventTouchBegin
        x = event.touch.x
        y = event.touch.y
        on_click(x, y, h)
      when LibAllegro::EventMouseButtonUp
        x = event.mouse.x
        y = event.mouse.y
        on_click(x, y, h)
      end
    end

    LibAllegro.destroy_bitmap(example.bitmap)
  end

  def on_click(x, y, h)
    fh = LibAllegro.get_font_line_height(example.font)

    if x < fh * 12 && y >= h - fh * 30
      button = (y - (h - fh * 30)) / (fh * 6)
      case button
      when 0
        example.use_memory_bitmaps ^= true
        change_size(example.bitmap_size)
      when 1
        example.blending += 1
        example.blending = 0 if example.blending == 4
      when 3
        if x < fh * 6
          remove_sprites(example.sprite_count / 2)
        else
          add_sprites(example.sprite_count)
        end
      when 2
        s = example.bitmap_size * 2
        s = example.bitmap_size / 2 if x < fh * 6
        change_size(s)
      when 4
        example.show_help ^= true
      end
    end
  end
end

ExDrawBitmap.new.main
