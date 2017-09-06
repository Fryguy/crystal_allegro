# Crystal port of ex_convert.c from the Allegro examples.

# Image conversion example

require "../src/crystal_allegro"
require "./common"

include Common

private class AbortException < Exception
end

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

open_log

begin
  if ARGV.size < 2
    log_printf("This example needs to be run from the command line.\n")
    log_printf("Usage: %s <infile> <outfile>\n", $0)
    log_printf("\tPossible file types: BMP PCX PNG TGA\n")
    raise AbortException.new
  end

  LibAllegro.init_image_addon

  LibAllegro.set_new_bitmap_format(LibAllegro::PixelFormatArgb8888)
  LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)

  bitmap = LibAllegro.load_bitmap_flags(ARGV[0], LibAllegro::NoPremultipliedAlpha)
  unless bitmap
    log_printf("Error loading input file\n")
    raise AbortException.new
  end

  t0 = LibAllegro.get_time
  unless LibAllegro.save_bitmap(ARGV[1], bitmap)
    log_printf("Error saving bitmap\n")
    raise AbortException.new
  end
  t1 = LibAllegro.get_time
  log_printf("Saving took %.4f seconds\n", t1 - t0)

  LibAllegro.destroy_bitmap(bitmap)
rescue AbortException
ensure
  close_log(true)
end
