# Crystal port of ex_fs_window.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExFsWindow
  include Common

  property! display : Pointer(LibAllegro::Display)?
  property! picture : LibAllegro::Bitmap?
  property! queue : LibAllegro::EventQueue?
  property! font : LibAllegro::Font?
  property big : Bool?

  def redraw
    w = LibAllegro.get_display_width(display)
    h = LibAllegro.get_display_height(display)
    pw = LibAllegro.get_bitmap_width(picture)
    ph = LibAllegro.get_bitmap_height(picture)
    th = LibAllegro.get_font_line_height(font)
    cx = (w - pw) * 0.5
    cy = (h - ph) * 0.5
    white = LibAllegro.map_rgb_f(1, 1, 1)

    color = LibAllegro.map_rgb_f(0.8, 0.7, 0.9)
    LibAllegro.clear_to_color(color)

    color = LibAllegro.map_rgb(255, 0, 0)
    LibAllegro.draw_line(0, 0, w, h, color, 0)
    LibAllegro.draw_line(0, h, w, 0, color, 0)

    LibAllegro.draw_bitmap(picture, cx, cy, 0)

    LibAllegro.draw_textf(font, white, w / 2, cy + ph, LibAllegro::AlignCentre,
      "Press Space to toggle fullscreen")
    LibAllegro.draw_textf(font, white, w / 2, cy + ph + th, LibAllegro::AlignCentre,
      "Press Enter to toggle window size")
    LibAllegro.draw_textf(font, white, w / 2, cy + ph + th * 2, LibAllegro::AlignCentre,
      "Window: %dx%d (%s)",
      LibAllegro.get_display_width(display), LibAllegro.get_display_height(display),
      (LibAllegro.get_display_flags(display) & LibAllegro::FullscreenWindow != 0) ? "fullscreen" : "not fullscreen")

    LibAllegro.flip_display
  end

  def run
    event = uninitialized LibAllegro::Event
    quit = false
    until quit
      while LibAllegro.get_next_event(queue, pointerof(event)) != 0
        case event.type
        when LibAllegro::EventDisplayClose
          quit = true
        when LibAllegro::EventKeyDown
          case event.keyboard.keycode
          when LibAllegro::KeyEscape
            quit = true
          when LibAllegro::KeySpace
            opp = LibAllegro.get_display_flags(display) & LibAllegro::FullscreenWindow == 0
            LibAllegro.set_display_flag(display, LibAllegro::FullscreenWindow, opp ? 1 : 0)
            redraw
          when LibAllegro::KeyEnter
            self.big = !big
            if big
              LibAllegro.resize_display(display, 800, 600)
            else
              LibAllegro.resize_display(display, 640, 480)
            end
            redraw
          end
        end
      end
      # FIXME: Lazy timing
      LibAllegro.rest(0.02)
      redraw
    end
  end

  def main
    abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

    LibAllegro.init_primitives_addon
    LibAllegro.install_keyboard
    LibAllegro.init_image_addon
    LibAllegro.init_font_addon
    init_platform_specific

    LibAllegro.set_new_display_flags(LibAllegro::FullscreenWindow)
    display = self.display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    self.queue = LibAllegro.create_event_queue
    LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
    LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))

    picture = self.picture = LibAllegro.load_bitmap("data/mysha.pcx")
    abort_example("mysha.pcx not found\n") unless picture

    font = self.font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
    abort_example("data/fixed_font.tga not found.\n") unless font

    redraw
    run

    LibAllegro.destroy_display(display)

    LibAllegro.destroy_event_queue(queue)
  end
end

ExFsWindow.new.main
