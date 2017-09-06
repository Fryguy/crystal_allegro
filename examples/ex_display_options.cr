# Crystal port of ex_display_options.c from the Allegro examples.

# Test retrieving and settings possible modes.

require "../src/crystal_allegro"
require "./common"

class ExDisplayOptions
  include Common

  property! font : LibAllegro::Font?
  property! white : LibAllegro::Color?
  property font_h = 0
  property modes_count = 0
  property options_count = 0
  property status = ""
  property flags = 0
  property old_flags = 0

  property visible_rows = 0
  property first_visible_row = 0

  property selected_column = 0
  property selected_mode = 0
  property selected_option = 0

  macro x(x, m)
    Option.new("{{x}}", LibAllegro::{{x}}, 0, {{m}}, 0)
  end

  struct Option
    property name : String
    property option : Int32
    property value : Int32
    property max_value : Int32
    property required : Int32

    def initialize(@name, @option, @value, @max_value, @required)
    end
  end

  OPTIONS_INIT = [
    x(ColorSize, 32),
    x(RedSize, 8),
    x(GreenSize, 8),
    x(BlueSize, 8),
    x(AlphaSize, 8),
    x(RedShift, 32),
    x(GreenShift, 32),
    x(BlueShift, 32),
    x(AlphaShift, 32),
    x(DepthSize, 32),
    x(FloatColor, 1),
    x(FloatDepth, 1),
    x(StencilSize, 32),
    x(SampleBuffers, 1),
    x(Samples, 8),
    x(RenderMethod, 2),
    x(SingleBuffer, 1),
    x(SwapMethod, 1),
    x(Vsync, 2),
    x(CompatibleDisplay, 1),
    x(MaxBitmapSize, 65536),
    x(SupportNpotBitmap, 1),
    x(CanDrawIntoBitmap, 1),
    x(SupportSeparateAlpha, 1),
  ]
  property options : Array(Option) = OPTIONS_INIT

  macro y(f, i)
    flag_names[{{i}}] = "{{f}}" if 1 << {{i}} == LibAllegro::{{f}}
  end

  property flag_names = StaticArray(String, 32).new("")

  def init_flags
    32.times do |i|
      y(Windowed, i)
      y(Fullscreen, i)
      y(Opengl, i)
      y(Resizable, i)
      y(Frameless, i)
      y(GenerateExposeEvents, i)
      y(FullscreenWindow, i)
      y(Minimized, i)
    end
  end

  def load_font
    self.font = LibAllegro.create_builtin_font
    abort_example("Error creating builtin font\n") unless @font
    self.font_h = LibAllegro.get_font_line_height(font)
  end

  def display_options(display)
    i = y = 10
    x = 10
    n = options_count
    dw = LibAllegro.get_display_width(display)
    dh = LibAllegro.get_display_height(display)

    self.modes_count = LibAllegro.get_num_display_modes

    c = LibAllegro.map_rgb_f(0.8, 0.8, 1)
    LibAllegro.draw_textf(font, c, x, y, 0, "Create new display")
    y += font_h
    i = first_visible_row
    while i < modes_count + 2 && i < first_visible_row + visible_rows
      mode = LibAllegro::DisplayMode.new
      if i > 1
        LibAllegro.get_display_mode(i - 2, pointerof(mode))
      elsif i == 1
        mode.width = 800
        mode.height = 600
        mode.format = 0
        mode.refresh_rate = 0
      else
        mode.width = 800
        mode.height = 600
        mode.format = 0
        mode.refresh_rate = 0
      end
      if selected_column == 0 && selected_mode == i
        c = LibAllegro.map_rgb_f(1, 1, 0)
        LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
        LibAllegro.draw_filled_rectangle(x, y, x + 300, y + font_h, c)
      end
      c = LibAllegro.map_rgb_f(0, 0, 0)
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      if (i == first_visible_row && i > 0) ||
         (i == first_visible_row + visible_rows - 1 &&
         i < modes_count + 1)
        LibAllegro.draw_textf(font, c, x, y, 0, "...")
      else
        LibAllegro.draw_textf(font, c, x, y, 0, "%s %d x %d (fmt: %x, %d Hz)",
          i > 1 ? "Fullscreen" : i == 0 ? "Windowed" : "FS Window",
          mode.width, mode.height, mode.format, mode.refresh_rate)
      end
      y += font_h

      i += 1
    end

    x = dw / 2 + 10
    y = 10
    c = LibAllegro.map_rgb_f(0.8, 0.8, 1)
    LibAllegro.draw_textf(font, c, x, y, 0, "Options for new display")
    LibAllegro.draw_textf(font, c, dw - 10, y, LibAllegro::AlignRight, "(current display)")
    y += font_h
    n.times do |i|
      if selected_column == 1 && selected_option == i
        c = LibAllegro.map_rgb_f(1, 1, 0)
        LibAllegro.draw_filled_rectangle(x, y, x + 300, y + font_h, c)
      end

      case options[i].required
      when LibAllegro::Require  then c = LibAllegro.map_rgb_f(0.5, 0, 0)
      when LibAllegro::Suggest  then c = LibAllegro.map_rgb_f(0, 0, 0)
      when LibAllegro::Dontcare then c = LibAllegro.map_rgb_f(0.5, 0.5, 0.5)
      end
      LibAllegro.draw_textf(font, c, x, y, 0, "%s: %d (%s)", options[i].name,
        options[i].value,
        options[i].required == LibAllegro::Require ? "required" : options[i].required == LibAllegro::Suggest ? "suggested" : "ignored")

      c = LibAllegro.map_rgb_f(0.9, 0.5, 0.3)
      LibAllegro.draw_textf(font, c, dw - 10, y, LibAllegro::AlignRight, "%d",
        LibAllegro.get_display_option(display, options[i].option))
      y += font_h
    end

    c = LibAllegro.map_rgb_f(0, 0, 0.8)
    x = 10
    y = dh - font_h - 10
    y -= font_h
    LibAllegro.draw_textf(font, c, x, y, 0, "PageUp/Down: modify values")
    y -= font_h
    LibAllegro.draw_textf(font, c, x, y, 0, "Return: set mode or require option")
    y -= font_h
    LibAllegro.draw_textf(font, c, x, y, 0, "Cursor keys: change selection")

    y -= font_h * 2
    32.times do |i|
      if flag_names[i]
        if flags & (1 << i) != 0
          c = LibAllegro.map_rgb_f(0.5, 0, 0)
        elsif old_flags & (1 << i) != 0
          c = LibAllegro.map_rgb_f(0.5, 0.4, 0.4)
        else
          next
        end
        LibAllegro.draw_text(font, c, x, y, 0, flag_names[i])
        x += LibAllegro.get_text_width(font, flag_names[i]) + 10
      end
    end

    c = LibAllegro.map_rgb_f(1, 0, 0)
    LibAllegro.draw_text(font, c, dw / 2, dh - font_h, LibAllegro::AlignCentre, status)
  end

  def update_ui
    h = LibAllegro.get_display_height(LibAllegro.get_current_display)
    self.visible_rows = h / font_h - 10
  end

  def main
    redraw = false

    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init
    init_flags
    LibAllegro.init_primitives_addon

    self.white = LibAllegro.map_rgba_f(1, 1, 1, 1)

    LibAllegro.install_keyboard
    LibAllegro.install_mouse
    LibAllegro.init_font_addon

    display = LibAllegro.create_display(800, 600)
    abort_example("Could not create display.\n") unless display

    load_font

    timer = LibAllegro.create_timer(1.0 / 60)

    self.modes_count = LibAllegro.get_num_display_modes
    self.options_count = options.size

    update_ui

    LibAllegro.clear_to_color(LibAllegro.map_rgb_f(1, 1, 1))
    display_options(display)
    LibAllegro.flip_display

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
      when LibAllegro::EventMouseButtonDown
        if event.mouse.button == 1
          dw = LibAllegro.get_display_width(display)
          y = 10
          row = (event.mouse.y - y) / font_h - 1
          column = event.mouse.x / (dw / 2)
          if column == 0
            if row >= 0 && row <= modes_count
              self.selected_column = column
              self.selected_mode = row
              redraw = true
            end
          end
          if column == 1
            if row >= 0 && row < options_count
              self.selected_column = column
              self.selected_option = row
              redraw = true
            end
          end
        end
      when LibAllegro::EventTimer
        f = LibAllegro.get_display_flags(display)
        if f != flags
          redraw = true
          self.flags = f
          self.old_flags |= f
        end
      when LibAllegro::EventKeyChar
        case event.keyboard.keycode
        when LibAllegro::KeyEscape
          break
        when LibAllegro::KeyLeft
          self.selected_column = 0
          redraw = true
        when LibAllegro::KeyRight
          self.selected_column = 1
          redraw = true
        when LibAllegro::KeyUp
          self.selected_mode -= 1 if selected_column == 0
          self.selected_option -= 1 if selected_column == 1
          redraw = true
        when LibAllegro::KeyDown
          self.selected_mode += 1 if selected_column == 0
          self.selected_option += 1 if selected_column == 1
          redraw = true
        when LibAllegro::KeyEnter
          if selected_column == 0
            mode = LibAllegro::DisplayMode.new
            if selected_mode > 1
              LibAllegro.get_display_mode(selected_mode - 2, pointerof(mode))
              LibAllegro.set_new_display_flags(LibAllegro::Fullscreen)
            elsif selected_mode == 1
              mode.width = 800
              mode.height = 600
              LibAllegro.set_new_display_flags(LibAllegro::FullscreenWindow)
            else
              mode.width = 800
              mode.height = 600
              LibAllegro.set_new_display_flags(LibAllegro::Windowed)
            end

            LibAllegro.destroy_font(font)
            self.font = nil

            new_display = LibAllegro.create_display(
              mode.width, mode.height)
            if new_display
              LibAllegro.destroy_display(display)
              display = new_display
              LibAllegro.set_target_backbuffer(display)
              LibAllegro.register_event_source(queue,
                LibAllegro.get_display_event_source(display))
              update_ui
              self.status = "Display creation succeeded."
            else
              self.status = "Display creation failed."
            end

            load_font
          end
          if selected_column == 1
            options[selected_option].required += 1
            options[selected_option].required %= 3
            LibAllegro.set_new_display_option(
              options[selected_option].option,
              options[selected_option].value,
              options[selected_option].required)
          end
          redraw = true
        end
        change = 0
        change = 1 if event.keyboard.keycode == LibAllegro::KeyPgup
        change = -1 if event.keyboard.keycode == LibAllegro::KeyPgdn
        if change != 0 && selected_column == 1
          options[selected_option].value += change
          if options[selected_option].value < 0
            options[selected_option].value = 0
          end
          if options[selected_option].value >
               options[selected_option].max_value
            options[selected_option].value =
              options[selected_option].max_value
          end
          LibAllegro.set_new_display_option(options[selected_option].option,
            options[selected_option].value,
            options[selected_option].required)
          redraw = true
        end
      end

      if selected_mode < 0
        self.selected_mode = 0
      end
      if selected_mode > modes_count + 1
        self.selected_mode = modes_count + 1
      end
      if selected_option < 0
        self.selected_option = 0
      end
      if selected_option >= options_count
        self.selected_option = options_count - 1
      end
      if selected_mode < first_visible_row
        self.first_visible_row = selected_mode
      end
      if selected_mode > first_visible_row + visible_rows - 1
        self.first_visible_row = selected_mode - visible_rows + 1
      end

      if redraw && LibAllegro.is_event_queue_empty(queue)
        redraw = false
        LibAllegro.clear_to_color(LibAllegro.map_rgb_f(1, 1, 1))
        display_options(display)
        LibAllegro.flip_display
      end
    end

    LibAllegro.destroy_font(font)
  end
end

ExDisplayOptions.new.main
