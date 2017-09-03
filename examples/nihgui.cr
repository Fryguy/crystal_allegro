# Crystal port of nihgui.cpp/hpp from the Allegro examples.

# This is a GUI for example programs that require GUI-style interaction.
# It's intended to be as simple and transparent as possible (simplistic,
# even).

require "../src/crystal_allegro"

macro clamp(x, y, z)
  [{{x}}, [{{y}}, {{z}}].min].max
end

class SaveState
  def initialize(save = LibAllegro::StateAll)
    state = uninitialized LibAllegro::State
    LibAllegro.store_state(pointerof(state), save)

    begin
      yield
    ensure
      LibAllegro.restore_state(pointerof(state))
    end
  end
end

class UString
  private property info
  private property ustr

  def initialize(s, first, last = -1)
    @info = uninitialized LibAllegro::UstrInfo
    last = LibAllegro.ustr_size(s) if last == -1
    @ustr = LibAllegro.ref_ustr(pointerof(@info), s, first, last)
  end

  def to_unsafe
    ustr
  end
end

class Theme
  property bg
  property fg
  property highlight
  property! font : LibAllegro::Font?

  # Null font is fine if you don't use a widget that requires text.
  def initialize(font = nil)
    @bg = LibAllegro.map_rgb(255, 255, 255)
    @fg = LibAllegro.map_rgb(0, 0, 0)
    @highlight = LibAllegro.map_rgb(128, 128, 255)
    @font = font
  end
end

abstract class Widget
  property grid_x
  property grid_y
  property grid_w
  property grid_h

  property! dialog : Dialog?
  property x1
  property y1
  property x2
  property y2
  property? disabled

  def initialize
    @grid_x = @grid_y = @grid_w = @grid_h = 0
    @dialog = nil
    @x1 = @x2 = @y1 = @y2 = 0
    @disabled = false
  end

  def configure(xsize, ysize, x_padding, y_padding)
    self.x1 = xsize * grid_x + x_padding
    self.y1 = ysize * grid_y + y_padding
    self.x2 = xsize * (grid_x + grid_w) - x_padding - 1
    self.y2 = ysize * (grid_y + grid_h) - y_padding - 1
  end

  def contains(x, y)
    x >= x1 && y >= y1 && x <= x2 && y <= y2
  end

  def width
    x2 - x1 + 1
  end

  def height
    y2 - y1 + 1
  end

  def want_mouse_focus
    true
  end

  def got_mouse_focus
  end

  def lost_mouse_focus
  end

  def on_mouse_button_down(mx, my)
  end

  def on_mouse_button_hold(mx, my)
  end

  def on_mouse_button_up(mx, my)
  end

  def on_click(mx, my)
  end

  def want_key_focus
    false
  end

  def got_key_focus
  end

  def lost_key_focus
  end

  def on_key_down(event)
  end

  abstract def draw
end

abstract class EventHandler
  abstract def handle_event(event)
end

class Dialog
  getter theme : Theme
  private setter theme

  private property display : LibAllegro::Display*
  private property event_queue
  private property grid_m : Int32
  private property grid_n : Int32
  private property x_padding
  private property y_padding

  getter? draw_requested
  private setter draw_requested
  getter? quit_requested
  private setter quit_requested

  private property all_widgets
  private property mouse_over_widget : Widget?
  private property mouse_down_widget : Widget?
  private property key_widget : Widget?

  private getter event_handler : EventHandler?
  setter event_handler : EventHandler?

  def initialize(@theme, @display, @grid_m, @grid_n)
    @x_padding = @y_padding = 1

    @draw_requested = true
    @quit_requested = false
    @all_widgets = [] of Widget

    @event_queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(event_queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(event_queue, LibAllegro.get_mouse_event_source)
    LibAllegro.register_event_source(event_queue, LibAllegro.get_display_event_source(display))
    # if LibAllegro.is_touch_input_installed
    #   LibAllegro.register_event_source(event_queue,
    #      LibAllegro.get_touch_input_mouse_emulation_event_source)
    # end
  end

  def finalize
    # XXX
    LibAllegro.destroy_event_queue(event_queue)
  end

  def set_padding(@x_padding, @y_padding)
  end

  def add(widget, grid_x, grid_y, grid_w, grid_h)
    widget.grid_x = grid_x
    widget.grid_y = grid_y
    widget.grid_w = grid_w
    widget.grid_h = grid_h

    all_widgets << widget
    widget.dialog = self
  end

  def prepare
    configure_all

    # XXX this isn't working right in X.  The mouse position is reported as
    # (0,0) initially, until the mouse pointer is moved.
    mst = uninitialized LibAllegro::MouseState
    LibAllegro.get_mouse_state(pointerof(mst))
    check_mouse_over(mst.x, mst.y)
  end

  private def configure_all
    xsize = LibAllegro.get_display_width(display) / grid_m
    ysize = LibAllegro.get_display_height(display) / grid_n

    all_widgets.each do |it|
      it.configure(xsize, ysize, x_padding, y_padding)
    end
  end

  def run_step(block)
    event = uninitialized LibAllegro::Event

    LibAllegro.wait_for_event(event_queue, nil) if block

    while LibAllegro.get_next_event(event_queue, pointerof(event)) != 0
      case event.type
      when LibAllegro::EventDisplayClose
        request_quit
      when LibAllegro::EventKeyChar
        on_key_down(event.keyboard)
      when LibAllegro::EventMouseAxes
        on_mouse_axes(event.mouse)
      when LibAllegro::EventMouseButtonDown
        on_mouse_button_down(event.mouse)
      when LibAllegro::EventMouseButtonUp
        on_mouse_button_up(event.mouse)
      when LibAllegro::EventDisplayExpose
        request_draw
      else
        event_handler.try &.handle_event(event)
      end
    end
  end

  private def on_key_down(event)
    return if event.display.address != display.address

    # XXX think of something better when we need it
    request_quit if event.keycode == LibAllegro::KeyEscape

    key_widget.try &.on_key_down(event)
  end

  private def on_mouse_axes(event)
    mx = event.x
    my = event.y

    return if event.display.address != display.address

    if (widget = mouse_down_widget)
      widget.on_mouse_button_hold(mx, my)
      return
    end

    check_mouse_over(mx, my)
  end

  private def check_mouse_over(mx, my)
    if mouse_over_widget.try &.contains(mx, my)
      # no change
      return
    end

    all_widgets.each do |it|
      if it.contains(mx, my) && it.want_mouse_focus
        self.mouse_over_widget = it
        it.got_mouse_focus
        return
      end
    end

    if (widget = mouse_over_widget)
      widget.lost_mouse_focus
      self.mouse_over_widget = nil
    end
  end

  private def on_mouse_button_down(event)
    return if event.button != 1

    # With touch input we may not receive mouse axes event before the touch
    # so we must check which widget the touch is over.
    check_mouse_over(event.x, event.y)
    return unless (widget = mouse_over_widget)

    self.mouse_down_widget = widget
    widget.on_mouse_button_down(event.x, event.y)

    # transfer key focus
    if widget != key_widget
      if key_widget
        key_widget.not_nil!.lost_key_focus
        self.key_widget = nil
      end
      if widget.want_key_focus
        self.key_widget = widget
        widget.got_key_focus
      end
    end
  end

  private def on_mouse_button_up(event)
    return if event.button != 1
    return unless (widget = mouse_down_widget)

    widget.on_mouse_button_up(event.x, event.y)
    if widget.contains(event.x, event.y)
      widget.on_click(event.x, event.y)
    end
    self.mouse_down_widget = nil
  end

  def request_quit
    self.quit_requested = true
  end

  def request_draw
    self.draw_requested = true
  end

  def draw
    cx = uninitialized Int32
    cy = uninitialized Int32
    cw = uninitialized Int32
    ch = uninitialized Int32
    LibAllegro.get_clipping_rectangle(pointerof(cx), pointerof(cy), pointerof(cw), pointerof(ch))

    all_widgets.each do |wid|
      LibAllegro.set_clipping_rectangle(wid.x1, wid.y1, wid.width, wid.height)
      wid.draw
    end

    LibAllegro.set_clipping_rectangle(cx, cy, cw, ch)

    self.draw_requested = false
  end

  def register_event_source(source)
    LibAllegro.register_event_source(event_queue, source)
  end
end

class Label < Widget
  private getter text
  setter text
  private property centred

  def initialize(@text = "", @centred = true)
    super()
  end

  def draw
    theme = dialog.theme

    SaveState.new do
      fg = theme.fg

      fg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      if centred
        LibAllegro.draw_text(theme.font, fg, (x1 + x2 + 1) / 2,
          y1, LibAllegro::AlignCentre, text)
      else
        LibAllegro.draw_text(theme.font, fg, x1, y1, 0, text)
      end
    end
  end

  def want_mouse_focus
    false
  end
end

class Button < Widget
  private property text : String
  getter? pushed
  private setter pushed

  def initialize(@text)
    @pushed = false
    super()
  end

  def on_mouse_button_down(mx, my)
    return if disabled?

    self.pushed = true
    dialog.request_draw
  end

  def on_mouse_button_up(mx, my)
    return if disabled?

    self.pushed = false
    dialog.request_draw
  end

  def draw
    theme = dialog.theme

    SaveState.new do
      if pushed?
        fg = theme.bg
        bg = theme.fg
      else
        fg = theme.fg
        bg = theme.bg
      end

      bg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.draw_filled_rectangle(x1, y1,
        x2, y2, bg)
      LibAllegro.draw_rectangle(x1 + 0.5, y1 + 0.5,
        x2 - 0.5, y2 - 0.5, fg, 0)
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)

      # Center the text vertically in the button, taking the font size
      # into consideration.
      y = (y1 + y2 - LibAllegro.get_font_line_height(theme.font) - 1) / 2

      LibAllegro.draw_text(theme.font, fg, (x1 + x2 + 1) / 2,
        y1, LibAllegro::AlignCentre, text)
    end
  end
end

class ToggleButton < Button
  def on_mouse_button_down(mx, my)
    return if disabled?

    self.pushed = !pushed?
  end

  def on_mouse_button_up(mx, my)
    return if disabled?
  end

  def pushed=(pushed)
    if @pushed != pushed
      self.pushed = pushed
      dialog.request_draw if @dialog
    end
  end
end

class List < Widget
  private EMPTY_STRING = ""

  private property items
  private setter selected_item
  getter selected_item

  def initialize(initial_selection = 0)
    @items = [] of String
    @selected_item = initial_selection
    super()
  end

  def want_key_focus
    !disabled?
  end

  def on_key_down(event)
    return if disabled?

    case event.keycode
    when LibAllegro::KeyDown
      if selected_item < items.size - 1
        self.selected_item += 1
        dialog.request_draw
      end
    when LibAllegro::KeyUp
      if selected_item > 0
        self.selected_item -= 1
        dialog.request_draw
      end
    end
  end

  def on_click(mx, my)
    return if disabled?

    theme = dialog.theme
    i = (my - y1) / LibAllegro.get_font_line_height(theme.font)
    if i < items.size
      self.selected_item = i
      dialog.request_draw
    end
  end

  def draw
    theme = dialog.theme

    SaveState.new do
      bg = theme.bg

      bg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.draw_filled_rectangle(x1 + 1, y1 + 1, x2 - 1, y2 - 1, bg)

      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      font_height = LibAllegro.get_font_line_height(theme.font)
      items.each_with_index do |item, i|
        yi = y1 + i * font_height

        if i == selected_item
          LibAllegro.draw_filled_rectangle(x1 + 1, yi, x2 - 1, yi + font_height - 1,
            theme.highlight)
        end

        LibAllegro.draw_text(theme.font, theme.fg, x1, yi, 0, item)
      end
    end
  end

  def clear_items
    items.clear
    self.selected_item = 0
  end

  def append_item(text)
    items << text
  end

  def selected_item_text
    if selected_item < items.size
      items[selected_item]
    else
      EMPTY_STRING
    end
  end
end

class VSlider < Widget
  property cur_value
  private setter max_value
  getter max_value

  def initialize(@cur_value = 0, @max_value = 1)
    super()
  end

  def on_mouse_button_down(mx, my)
    return if disabled?

    on_mouse_button_hold(mx, my)
  end

  def on_mouse_button_hold(mx, my)
    return if disabled?

    r = (y2 - 1 - my).to_f / (height - 2)
    r = clamp(0.0, r, 1.0)
    self.cur_value = (r * max_value).to_i
    dialog.request_draw
  end

  def draw
    theme = dialog.theme
    bg = theme.fg
    left = x1 + 0.5
    top = y1 + 0.5
    right = x2 + 0.5
    bottom = y2 + 0.5

    SaveState.new do
      bg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.draw_rectangle(left, top, right, bottom, bg, 1)

      ratio = cur_value.to_f / max_value.to_f
      ypos = (bottom - 0.5 - (ratio * (height - 7)).to_i).to_i
      LibAllegro.draw_filled_rectangle(left + 0.5, ypos - 5, right - 0.5, ypos, theme.fg)
    end
  end
end

class HSlider < Widget
  property cur_value
  private setter max_value
  getter max_value

  def initialize(@cur_value = 0, @max_value = 1)
    super()
  end

  def on_mouse_button_down(mx, my)
    return if disabled?

    on_mouse_button_hold(mx, my)
  end

  def on_mouse_button_hold(mx, my)
    return if disabled?

    r = (mx - 1 - x1).to_f / (width - 2)
    r = clamp(0.0, r, 1.0)
    self.cur_value = (r * max_value).to_i
    dialog.request_draw
  end

  def draw
    theme = dialog.theme
    cy = (y1 + y2) / 2

    SaveState.new do
      bg = theme.bg

      bg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.draw_filled_rectangle(x1, y1, x2, y2, bg)
      LibAllegro.draw_line(x1, cy, x2, cy, theme.fg, 0)

      ratio = cur_value.to_f / max_value.to_f
      xpos = x1 + (ratio * (width - 2)).to_i
      LibAllegro.draw_filled_rectangle(xpos - 2, y1, xpos + 2, y2, theme.fg)
    end
  end
end

class TextEntry < Widget
  private CURSOR_WIDTH = 8

  private property text
  private property? focused
  private property cursor_pos
  private property left_pos

  def initialize(initial_text = "")
    @focused = false
    @cursor_pos = 0
    @left_pos = 0
    @text = LibAllegro.ustr_new(initial_text)
    super()
  end

  def finalize
    LibAllegro.ustr_free(text)
  end

  def want_key_focus
    !disabled?
  end

  def got_key_focus
    self.focused = true
    dialog.request_draw
  end

  def lost_key_focus
    self.focused = false
    dialog.request_draw
  end

  def on_key_down(event)
    return if disabled?

    case event.keycode
    when LibAllegro::KeyLeft
      LibAllegro.ustr_prev(text, pointerof(@cursor_pos))
    when LibAllegro::KeyRight
      LibAllegro.ustr_next(text, pointerof(@cursor_pos))
    when LibAllegro::KeyHome
      self.cursor_pos = 0
    when LibAllegro::KeyEnd
      self.cursor_pos = LibAllegro.ustr_size(text).to_i32
    when LibAllegro::KeyDelete
      LibAllegro.ustr_remove_chr(text, cursor_pos)
    when LibAllegro::KeyBackspace
      if LibAllegro.ustr_prev(text, pointerof(@cursor_pos)) != 0
        LibAllegro.ustr_remove_chr(text, cursor_pos)
      end
    else
      if event.unichar >= ' '.ord
        LibAllegro.ustr_insert_chr(text, cursor_pos, event.unichar)
        self.cursor_pos = cursor_pos + LibAllegro.utf8_width(event.unichar)
      end
    end

    maybe_scroll
    dialog.request_draw
  end

  private def maybe_scroll
    theme = dialog.theme

    if cursor_pos < left_pos + 3
      if cursor_pos < 3
        self.left_pos = 0
      else
        self.left_pos = cursor_pos - 3
      end
    else
      loop do
        tw = LibAllegro.get_ustr_width(theme.font,
          UString.new(text, left_pos, cursor_pos))
        break if x1 + tw + CURSOR_WIDTH < x2
        LibAllegro.ustr_next(text, pointerof(@left_pos))
      end
    end
  end

  def draw
    theme = dialog.theme

    SaveState.new do
      bg = theme.bg

      bg = LibAllegro.map_rgb(64, 64, 64) if disabled?

      LibAllegro.draw_filled_rectangle(x1, y1, x2, y2, bg)

      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)

      if !focused?
        LibAllegro.draw_ustr(theme.font, theme.fg, x1, y1, 0, UString.new(text, left_pos))
      else
        x = x1

        if cursor_pos > 0
          sub = UString.new(text, left_pos, cursor_pos)
          LibAllegro.draw_ustr(theme.font, theme.fg, x1, y1, 0, sub)
          x += LibAllegro.get_ustr_width(theme.font, sub)
        end

        if cursor_pos == LibAllegro.ustr_size(text)
          LibAllegro.draw_filled_rectangle(x, y1, x + CURSOR_WIDTH,
            y1 + LibAllegro.get_font_line_height(theme.font), theme.fg)
        else
          post_cursor = cursor_pos
          LibAllegro.ustr_next(text, pointerof(post_cursor))

          sub = UString.new(text, cursor_pos, post_cursor)
          subw = LibAllegro.get_ustr_width(theme.font, sub)
          LibAllegro.draw_filled_rectangle(x, y1, x + subw,
            y1 + LibAllegro.get_font_line_height(theme.font), theme.fg)
          LibAllegro.draw_ustr(theme.font, theme.bg, x, y1, 0, sub)
          x += subw

          LibAllegro.draw_ustr(theme.font, theme.fg, x, y1, 0,
            UString.new(text, post_cursor))
        end
      end
    end
  end

  def get_text
    String.new(LibAllegro.cstr(text))
  end
end
