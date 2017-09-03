# Crystal port of ex_blend2.cpp from the Allegro examples.

# Example program for the Allegro library, by Peter Wang.
#
# Compare software blending routines with hardware blending.

require "../src/crystal_allegro"
require "./common"
require "./nihgui"

class ExBlend2
  extend Common

  class_property! allegro : LibAllegro::Bitmap?
  class_property! mysha : LibAllegro::Bitmap?
  class_property! allegro_bmp : LibAllegro::Bitmap?
  class_property! mysha_bmp : LibAllegro::Bitmap?
  class_property! target : LibAllegro::Bitmap?
  class_property! target_bmp : LibAllegro::Bitmap?

  class Prog
    private property d
    private property memory_label
    private property texture_label
    private property source_label
    private property destination_label
    private property source_image
    private property destination_image
    private property draw_mode
    private property operation_label
    private property operations
    private property rgba_label
    private property r
    private property g
    private property b
    private property a

    def initialize(theme, display)
      @d = Dialog.new(theme, display, 20, 40)
      @memory_label = Label.new("Memory")
      @texture_label = Label.new("Texture")
      @source_label = Label.new
      @source_label = Label.new("Source", false)
      @destination_label = Label.new("Destination", false)
      @source_image = List.new(0)
      @destination_image = List.new(1)
      @draw_mode = List.new(0)
      @operation_label = [] of Label
      @operations = [] of List
      @rgba_label = [] of Label
      @r = [] of HSlider
      @g = [] of HSlider
      @b = [] of HSlider
      @a = [] of HSlider

      d.add(memory_label, 9, 0, 10, 2)
      d.add(texture_label, 0, 0, 10, 2)
      d.add(source_label, 1, 15, 6, 2)
      d.add(destination_label, 7, 15, 6, 2)

      images = [source_image, destination_image, draw_mode]
      images.each_with_index do |image, i|
        if (i < 2)
          image.append_item("Mysha")
          image.append_item("Allegro")
          image.append_item("Mysha (tinted)")
          image.append_item("Allegro (tinted)")
          image.append_item("Color")
        else
          image.append_item("original")
          image.append_item("scaled")
          image.append_item("rotated")
        end
        d.add(image, 1 + i * 6, 17, 4, 6)
      end

      4.times do |i|
        operation_label << Label.new(i % 2 == 0 ? "Color" : "Alpha", false)
        d.add(operation_label[i], 1 + i * 3, 24, 3, 2)
        operations << (l = List.new)
        l.append_item("ONE")
        l.append_item("ZERO")
        l.append_item("ALPHA")
        l.append_item("INVERSE")
        l.append_item("SRC_COLOR")
        l.append_item("DEST_COLOR")
        l.append_item("INV_SRC_COLOR")
        l.append_item("INV_DEST_COLOR")
        d.add(l, 1 + i * 3, 25, 3, 9)
      end

      (4...6).each do |i|
        operation_label << Label.new(i == 4 ? "Blend op" : "Alpha op", false)
        d.add(operation_label[i], 1 + i * 3, 24, 3, 2)
        operations << (l = List.new)
        l.append_item("ADD")
        l.append_item("SRC_MINUS_DEST")
        l.append_item("DEST_MINUS_SRC")
        d.add(l, 1 + i * 3, 25, 3, 6)
      end

      rgba_label << Label.new("Source tint/color RGBA")
      rgba_label << Label.new("Dest tint/color RGBA")
      rgba_label << Label.new("Const color RGBA")
      d.add(rgba_label[0], 1, 34, 5, 1)
      d.add(rgba_label[1], 7, 34, 5, 1)
      d.add(rgba_label[2], 13, 34, 5, 1)

      3.times do |i|
        r << HSlider.new(255, 255)
        g << HSlider.new(255, 255)
        b << HSlider.new(255, 255)
        a << HSlider.new(255, 255)
        d.add(r[i], 1 + i * 6, 35, 5, 1)
        d.add(g[i], 1 + i * 6, 36, 5, 1)
        d.add(b[i], 1 + i * 6, 37, 5, 1)
        d.add(a[i], 1 + i * 6, 38, 5, 1)
      end
    end

    def run
      d.prepare

      until d.quit_requested?
        if d.draw_requested?
          LibAllegro.clear_to_color(LibAllegro.map_rgb(128, 128, 128))
          draw_samples
          d.draw
          LibAllegro.flip_display
        end

        d.run_step(true)
      end
    end

    private def str_to_blend_mode(str)
      return LibAllegro::Zero if str == "ZERO"
      return LibAllegro::One if str == "ONE"
      return LibAllegro::SrcColor if str == "SRC_COLOR"
      return LibAllegro::DestColor if str == "DEST_COLOR"
      return LibAllegro::InverseSrcColor if str == "INV_SRC_COLOR"
      return LibAllegro::InverseDestColor if str == "INV_DEST_COLOR"
      return LibAllegro::Alpha if str == "ALPHA"
      return LibAllegro::InverseAlpha if str == "INVERSE"
      return LibAllegro::Add if str == "ADD"
      return LibAllegro::SrcMinusDest if str == "SRC_MINUS_DEST"
      return LibAllegro::DestMinusSrc if str == "DEST_MINUS_SRC"

      # ALLEGRO_ASSERT(false)
      LibAllegro::One
    end

    private def draw_background(x, y)
      c = [
        LibAllegro.map_rgba(0x66, 0x66, 0x66, 0xff),
        LibAllegro.map_rgba(0x99, 0x99, 0x99, 0xff),
      ]

      (320 / 16).times do |i|
        (200 / 16).times do |j|
          LibAllegro.draw_filled_rectangle(x + i * 16, y + j * 16,
            x + i * 16 + 16, y + j * 16 + 16,
            c[(i + j) & 1])
        end
      end
    end

    private def makecol(r, g, b, a)
      # Premultiply alpha
      rf = r / 255.0
      gf = g / 255.0
      bf = b / 255.0
      af = a / 255.0
      LibAllegro.map_rgba_f(rf * af, gf * af, bf * af, af)
    end

    private def draw_bitmap(str, how, memory, destination)
      i = destination ? 1 : 0
      rv = r[i].cur_value
      gv = g[i].cur_value
      bv = b[i].cur_value
      av = a[i].cur_value
      color = makecol(rv, gv, bv, av)

      if str.includes?("Mysha")
        bmp = memory ? ExBlend2.mysha_bmp : ExBlend2.mysha
      else
        bmp = memory ? ExBlend2.allegro_bmp : ExBlend2.allegro
      end

      if how == "original"
        if str == "Color"
          LibAllegro.draw_filled_rectangle(0, 0, 320, 200, color)
        elsif str.includes?("tint")
          LibAllegro.draw_tinted_bitmap(bmp, color, 0, 0, 0)
        else
          LibAllegro.draw_bitmap(bmp, 0, 0, 0)
        end
      elsif how == "scaled"
        w = LibAllegro.get_bitmap_width(bmp)
        h = LibAllegro.get_bitmap_height(bmp)
        s = 200.0 / h * 0.9
        if str == "Color"
          LibAllegro.draw_filled_rectangle(10, 10, 300, 180, color)
        elsif str.includes?("tint")
          LibAllegro.draw_tinted_scaled_bitmap(bmp, color, 0, 0, w, h,
            160 - w * s / 2, 100 - h * s / 2, w * s, h * s, 0)
        else
          LibAllegro.draw_scaled_bitmap(bmp, 0, 0, w, h,
            160 - w * s / 2, 100 - h * s / 2, w * s, h * s, 0)
        end
      elsif how == "rotated"
        if str == "Color"
          LibAllegro.draw_filled_circle(160, 100, 100, color)
        elsif str.includes?("tint")
          LibAllegro.draw_tinted_rotated_bitmap(bmp, color, 160, 100,
            160, 100, LibAllegro::PI / 8, 0)
        else
          LibAllegro.draw_rotated_bitmap(bmp, 160, 100,
            160, 100, LibAllegro::PI / 8, 0)
        end
      end
    end

    private def blending_test(memory)
      transparency = LibAllegro.map_rgba_f(0, 0, 0, 0)
      op = str_to_blend_mode(operations[4].selected_item_text)
      aop = str_to_blend_mode(operations[5].selected_item_text)
      src = str_to_blend_mode(operations[0].selected_item_text)
      asrc = str_to_blend_mode(operations[1].selected_item_text)
      dst = str_to_blend_mode(operations[2].selected_item_text)
      adst = str_to_blend_mode(operations[3].selected_item_text)
      rv = r[2].cur_value
      gv = g[2].cur_value
      bv = b[2].cur_value
      av = a[2].cur_value
      color = makecol(rv, gv, bv, av)

      # Initialize with destination.
      LibAllegro.clear_to_color(transparency) # Just in case.
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
      draw_bitmap(destination_image.selected_item_text,
        "original", memory, true)

      # Now draw the blended source over it.
      LibAllegro.set_separate_blender(op, src, dst, aop, asrc, adst)
      LibAllegro.set_blend_color(color)
      draw_bitmap(source_image.selected_item_text,
        draw_mode.selected_item_text, memory, false)
    end

    private def draw_samples
      state = uninitialized LibAllegro::State
      LibAllegro.store_state(pointerof(state), LibAllegro::StateTargetBitmap | LibAllegro::StateBlender)

      # Draw a background, in case our target bitmap will end up with
      # alpha in it.
      draw_background(40, 20)
      draw_background(400, 20)

      # Test standard blending.
      LibAllegro.set_target_bitmap(ExBlend2.target)
      blending_test(false)

      # Test memory blending.
      LibAllegro.set_target_bitmap(ExBlend2.target_bmp)
      blending_test(true)

      # Display results.
      LibAllegro.restore_state(pointerof(state))
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
      LibAllegro.draw_bitmap(ExBlend2.target, 40, 20, 0)
      LibAllegro.draw_bitmap(ExBlend2.target_bmp, 400, 20, 0)

      LibAllegro.restore_state(pointerof(state))
    end
  end

  def self.main
    abort_example("Could not init Allegro\n") unless CrystalAllegro.init
    LibAllegro.init_primitives_addon
    LibAllegro.install_keyboard
    LibAllegro.install_mouse

    LibAllegro.init_font_addon
    LibAllegro.init_image_addon
    init_platform_specific

    LibAllegro.set_new_display_flags(LibAllegro::GenerateExposeEvents)
    display = LibAllegro.create_display(800, 600)
    abort_example("Unable to create display\n") unless display

    font = LibAllegro.load_font("data/fixed_font.tga", 0, 0)
    abort_example("Failed to load data/fixed_font.tga\n") unless font
    self.allegro = LibAllegro.load_bitmap("data/allegro.pcx")
    abort_example("Failed to load data/allegro.pcx\n") unless allegro
    self.mysha = LibAllegro.load_bitmap("data/mysha256x256.png")
    abort_example("Failed to load data/mysha256x256.png\n") unless mysha

    self.target = LibAllegro.create_bitmap(320, 200)

    LibAllegro.add_new_bitmap_flag(LibAllegro::MemoryBitmap)
    self.allegro_bmp = LibAllegro.clone_bitmap(allegro)
    self.mysha_bmp = LibAllegro.clone_bitmap(mysha)
    self.target_bmp = LibAllegro.clone_bitmap(target)

    theme = Theme.new(font)
    prog = Prog.new(theme, display)
    prog.run

    LibAllegro.destroy_bitmap(allegro)
    LibAllegro.destroy_bitmap(allegro_bmp)
    LibAllegro.destroy_bitmap(mysha)
    LibAllegro.destroy_bitmap(mysha_bmp)
    LibAllegro.destroy_bitmap(target)
    LibAllegro.destroy_bitmap(target_bmp)

    LibAllegro.destroy_font(font)
  end
end

ExBlend2.main
