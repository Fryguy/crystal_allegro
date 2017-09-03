# Crystal port of ex_blend_test.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

class ExBlendTest
  include Common

  property test_only_index = 0
  property test_index = 0
  property test_display = false
  property display : Pointer(LibAllegro::Display)?

  def print_color(c)
    r = uninitialized Float32
    g = uninitialized Float32
    b = uninitialized Float32
    a = uninitialized Float32
    LibAllegro.unmap_rgba_f(c, pointerof(r), pointerof(g), pointerof(b), pointerof(a))
    log_printf("%.2f, %.2f, %.2f, %.2f", r, g, b, a)
  end

  def test(src_col, dst_col, src_format, dst_format,
           src, dst, src_a, dst_a, operation, verbose)
    LibAllegro.set_new_bitmap_format(dst_format)
    LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    dst_bmp = LibAllegro.create_bitmap(1, 1)
    LibAllegro.set_target_bitmap(dst_bmp)
    LibAllegro.clear_to_color(dst_col)
    if operation == 0
      LibAllegro.set_new_bitmap_format(src_format)
      src_bmp = LibAllegro.create_bitmap(1, 1)
      LibAllegro.set_target_bitmap(src_bmp)
      LibAllegro.clear_to_color(src_col)
      LibAllegro.set_target_bitmap(dst_bmp)
      LibAllegro.set_separate_blender(LibAllegro::Add, src, dst, LibAllegro::Add, src_a, dst_a)
      LibAllegro.draw_bitmap(src_bmp, 0, 0, 0)
      LibAllegro.destroy_bitmap(src_bmp)
    elsif operation == 1
      LibAllegro.set_separate_blender(LibAllegro::Add, src, dst, LibAllegro::Add, src_a, dst_a)
      LibAllegro.draw_pixel(0, 0, src_col)
    elsif operation == 2
      LibAllegro.set_separate_blender(LibAllegro::Add, src, dst, LibAllegro::Add, src_a, dst_a)
      LibAllegro.draw_line(0, 0, 1, 1, src_col, 0)
    end

    result = LibAllegro.get_pixel(dst_bmp, 0, 0)

    LibAllegro.set_target_backbuffer(display)

    if test_display
      LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
      LibAllegro.draw_bitmap(dst_bmp, 0, 0, 0)
    end

    LibAllegro.destroy_bitmap(dst_bmp)

    return result unless verbose

    log_printf("---\n")
    log_printf("test id: %d\n", test_index)

    log_printf("source     : ")
    print_color(src_col)
    log_printf(" %s format=%d mode=%d alpha=%d\n",
      operation == 0 ? "bitmap" : operation == 1 ? "pixel" : "prim",
      src_format, src, src_a)

    log_printf("destination: ")
    print_color(dst_col)
    log_printf(" format=%d mode=%d alpha=%d\n",
      dst_format, dst, dst_a)

    log_printf("result     : ")
    print_color(result)
    log_printf("\n")

    result
  end

  def same_color(c1, c2)
    r1 = uninitialized Float32
    g1 = uninitialized Float32
    b1 = uninitialized Float32
    a1 = uninitialized Float32
    r2 = uninitialized Float32
    g2 = uninitialized Float32
    b2 = uninitialized Float32
    a2 = uninitialized Float32
    LibAllegro.unmap_rgba_f(c1, pointerof(r1), pointerof(g1), pointerof(b1), pointerof(a1))
    LibAllegro.unmap_rgba_f(c2, pointerof(r2), pointerof(g2), pointerof(b2), pointerof(a2))
    dr = r1 - r2
    dg = g1 - g2
    db = b1 - b2
    da = a1 - a2
    d = Math.sqrt(dr * dr + dg * dg + db * db + da * da)
    d < 0.01
  end

  def get_factor(operation, alpha)
    case operation
    when LibAllegro::Zero         then return 0.0
    when LibAllegro::One          then return 1.0
    when LibAllegro::Alpha        then return alpha
    when LibAllegro::InverseAlpha then return 1.0 - alpha
    end
    0.0
  end

  def has_alpha(format)
    return false if format == LibAllegro::PixelFormatRgb888
    return false if format == LibAllegro::PixelFormatBgr888
    true
  end

  macro clamp(x)
    {{x}} > 1 ? 1 : {{x}}
  end

  def reference_implementation(src_col, dst_col, src_format, dst_format,
                               src_mode, dst_mode, src_alpha, dst_alpha, operation)
    sr = uninitialized Float32
    sg = uninitialized Float32
    sb = uninitialized Float32
    sa = uninitialized Float32
    dr = uninitialized Float32
    dg = uninitialized Float32
    db = uninitialized Float32
    da = uninitialized Float32

    LibAllegro.unmap_rgba_f(src_col, pointerof(sr), pointerof(sg), pointerof(sb), pointerof(sa))
    LibAllegro.unmap_rgba_f(dst_col, pointerof(dr), pointerof(dg), pointerof(db), pointerof(da))

    # Do we even have source alpha?
    sa = 1f32 if operation == 0 && !has_alpha(src_format)

    r = sr
    g = sg
    b = sb
    a = sa

    src = get_factor(src_mode, a)
    dst = get_factor(dst_mode, a)
    asrc = get_factor(src_alpha, a)
    adst = get_factor(dst_alpha, a)

    r = r * src + dr * dst
    g = g * src + dg * dst
    b = b * src + db * dst
    a = a * asrc + da * adst

    r = clamp(r)
    g = clamp(g)
    b = clamp(b)
    a = clamp(a)

    # Do we even have destination alpha?
    a = 1 unless has_alpha(dst_format)

    LibAllegro.map_rgba_f(r, g, b, a)
  end

  def do_test2(src_col, dst_col, src_format, dst_format,
               src_mode, dst_mode, src_alpha, dst_alpha, operation)
    self.test_index += 1

    return if test_only_index != 0 && test_index != test_only_index

    reference = reference_implementation(
      src_col, dst_col, src_format, dst_format,
      src_mode, dst_mode, src_alpha, dst_alpha, operation)

    result = test(src_col, dst_col, src_format,
      dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
      operation, false)

    if !same_color(reference, result)
      test(src_col, dst_col, src_format,
        dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
        operation, true)
      log_printf("expected   : ")
      print_color(reference)
      log_printf("\n")
      log_printf("FAILED\n")
    else
      log_printf(" OK")
    end

    if test_display
      dst_format = LibAllegro.get_display_format(display)
      from_display = LibAllegro.get_pixel(LibAllegro.get_backbuffer(display), 0, 0)
      reference = reference_implementation(
        src_col, dst_col, src_format, dst_format,
        src_mode, dst_mode, src_alpha, dst_alpha, operation)

      unless same_color(reference, from_display)
        test(src_col, dst_col, src_format,
          dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
          operation, true)
        log_printf("displayed  : ")
        print_color(from_display)
        log_printf("\n")
        log_printf("expected   : ")
        print_color(reference)
        log_printf("\n")
        log_printf("(FAILED on display)\n")
      end
    end
  end

  def do_test1(src_col, dst_col, src_format, dst_format)
    smodes = [LibAllegro::Alpha, LibAllegro::Zero, LibAllegro::One,
              LibAllegro::InverseAlpha]
    dmodes = [LibAllegro::InverseAlpha, LibAllegro::Zero, LibAllegro::One,
              LibAllegro::Alpha]
    4.times do |i|
      4.times do |j|
        4.times do |k|
          4.times do |l|
            3.times do |m|
              do_test2(src_col, dst_col,
                src_format, dst_format,
                smodes[i], dmodes[j], smodes[k], dmodes[l],
                m)
            end
          end
        end
      end
    end
  end

  macro c(*args)
    LibAllegro.map_rgba_f({{*args}})
  end

  def main
    src_colors = [] of LibAllegro::Color
    dst_colors = [] of LibAllegro::Color
    src_formats = [
      LibAllegro::PixelFormatAbgr8888,
      LibAllegro::PixelFormatBgr888,
    ]
    dst_formats = [
      LibAllegro::PixelFormatAbgr8888,
      LibAllegro::PixelFormatBgr888,
    ]
    src_colors << c(0, 0, 0, 1)
    src_colors << c(1, 1, 1, 1)
    dst_colors << c(1, 1, 1, 1)
    dst_colors << c(0, 0, 0, 0)

    ARGV.each do |argv|
      if argv == "-d"
        self.test_display = true
      else
        self.test_only_index = argv.to_i
      end
    end

    abort_example("Could not initialise Allegro\n") unless CrystalAllegro.init

    open_log

    LibAllegro.init_primitives_addon
    if test_display
      self.display = LibAllegro.create_display(100, 100)
      abort_example("Unable to create display\n") unless display
    end

    2.times do |i|
      2.times do |j|
        2.times do |l|
          2.times do |m|
            do_test1(
              src_colors[i],
              dst_colors[j],
              src_formats[l],
              dst_formats[m])
          end
        end
      end
    end
    log_printf("\nDone\n")

    if test_only_index != 0 && test_display
      event = uninitialized LibAllegro::Event
      LibAllegro.flip_display
      LibAllegro.install_keyboard
      queue = LibAllegro.create_event_queue
      LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
      LibAllegro.wait_for_event(queue, pointerof(event))
    end

    close_log(true)
  end
end

ExBlendTest.new.main
