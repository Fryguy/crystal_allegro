# Crystal port of ex_font.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

EURO = "\xe2\x82\xac"

def wait_for_esc(display)
  LibAllegro.install_keyboard
  queue = LibAllegro.create_event_queue
  LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
  LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
  screen_clone = LibAllegro.clone_bitmap(LibAllegro.get_target_bitmap)
  event = uninitialized LibAllegro::Event
  loop do
    LibAllegro.wait_for_event(queue, pointerof(event))
    case event.type
    when LibAllegro::EventDisplayClose
      break
    when LibAllegro::EventKeyDown
      break if event.keyboard.keycode == LibAllegro::KeyEscape
    when LibAllegro::EventDisplayExpose
      x = event.display.x
      y = event.display.y
      w = event.display.width
      h = event.display.height

      LibAllegro.draw_bitmap_region(screen_clone, x, y, w, h,
        x, y, 0)
      LibAllegro.update_display_region(x, y, w, h)
    end
  end
  LibAllegro.destroy_bitmap(screen_clone)
  LibAllegro.destroy_event_queue(queue)
end

ranges = [
  0x0020, 0x007F, # ASCII
  0x00A1, 0x00FF, # Latin 1
  0x0100, 0x017F, # Extended-A
  0x20AC, 0x20AC, # Euro
]

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

LibAllegro.init_image_addon
LibAllegro.init_font_addon
init_platform_specific

LibAllegro.set_new_display_option(LibAllegro::SingleBuffer, 1, LibAllegro::Suggest)
LibAllegro.set_new_display_flags(LibAllegro::GenerateExposeEvents)
display = LibAllegro.create_display(640, 480)
abort_example("Failed to create display\n") unless display
bitmap = LibAllegro.load_bitmap("data/mysha.pcx")
abort_example("Failed to load mysha.pcx\n") unless bitmap

f1 = LibAllegro.load_font("data/bmpfont.tga", 0, 0)
abort_example("Failed to load bmpfont.tga\n") unless f1

font_bitmap = LibAllegro.load_bitmap("data/a4_font.tga")
abort_example("Failed to load a4_font.tga\n") unless font_bitmap
f2 = LibAllegro.grab_font_from_bitmap(font_bitmap, 4, ranges)

f3 = LibAllegro.create_builtin_font
abort_example("Failed to create builtin font.\n") unless f3

# Draw background
LibAllegro.draw_scaled_bitmap(bitmap, 0, 0, 320, 240, 0, 0, 640, 480, 0)

# Draw red text
LibAllegro.draw_textf(f1, LibAllegro.map_rgb(255, 0, 0), 10, 10, 0, "red")

# Draw green text
LibAllegro.draw_textf(f1, LibAllegro.map_rgb(0, 255, 0), 120, 10, 0, "green")

# Draw a unicode symbol
LibAllegro.draw_textf(f2, LibAllegro.map_rgb(0, 0, 255), 60, 60, 0, "Mysha's 0.02#{EURO}")

# Draw a yellow text with the builtin font
LibAllegro.draw_textf(f3, LibAllegro.map_rgb(255, 255, 0), 20, 200, LibAllegro::AlignCenter,
  "a string from builtin font data")

# Draw all individual glyphs the f2 font's range in rainbow colors.
x = 10
y = 300
LibAllegro.draw_textf(f3, LibAllegro.map_rgb(0, 255, 255), x, y - 20, 0, "Draw glyphs: ")
4.times do |range|
  start = ranges[2 * range]
  stop = ranges[2 * range + 1]
  (start...stop).each do |index|
    # Use LibAllegro.get_glyph_advance for the stride.
    width = LibAllegro.get_glyph_advance(f2, index, LibAllegro::NoKerning)
    r = ((Math.sin(LibAllegro::PI * (index) * 36 / 360.0)) * 255.0).abs
    g = ((Math.sin(LibAllegro::PI * (index + 12) * 36 / 360.0)) * 255.0).abs
    b = ((Math.sin(LibAllegro::PI * (index + 24) * 36 / 360.0)) * 255.0).abs
    LibAllegro.draw_glyph(f2, LibAllegro.map_rgb(r, g, b), x, y, index)
    x += width
    if x > LibAllegro.get_display_width(display) - 10
      x = 10
      y += LibAllegro.get_font_line_height(f2)
    end
  end
end

LibAllegro.flip_display

wait_for_esc(display)

LibAllegro.destroy_bitmap(bitmap)
LibAllegro.destroy_bitmap(font_bitmap)
LibAllegro.destroy_font(f1)
LibAllegro.destroy_font(f2)
LibAllegro.destroy_font(f3)
