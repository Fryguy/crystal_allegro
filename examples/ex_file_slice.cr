# Crystal port of ex_expose.c from the Allegro examples.

#
# ex_file_slice - Use slices to pack many objects into a single file.
#
# This example packs two strings into a single file, and then uses a
# file slice to open them one at a time. While this usage is contrived,
# the same principle can be used to pack multiple images (for example)
# into a single file, and later read them back via Allegro's image loader.
#

require "../src/crystal_allegro"
require "./common"

include Common

BUFFER_SIZE = 1024

def pack_object(file, object, len)
  # First write the length of the object, so we know how big to make
  # the slice when it is opened later.
  LibAllegro.fwrite32le(file, len)
  LibAllegro.fwrite(file, object, len)
end

def get_next_chunk(file)
  # Reads the length of the next chunk, and if not at end of file, returns a
  # slice that represents that portion of the file.
  length = LibAllegro.fread32le(file)
  LibAllegro.feof(file) == 0 ? LibAllegro.fopen_slice(file, length, "rw") : nil
end

tmp_path = uninitialized LibAllegro::Path
first_string = "Hello, World!"
second_string = "The quick brown fox jumps over the lazy dog."
buffer = Pointer(UInt8).malloc(BUFFER_SIZE)

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

open_log

master = LibAllegro.make_temp_file("ex_file_slice_XXXX", pointerof(tmp_path))
abort_example("Unable to create temporary file\n") unless master

# Pack both strings into the master file.
pack_object(master, first_string, first_string.size)
pack_object(master, second_string, second_string.size)

# Seek back to the beginning of the file, as if we had just opened it
LibAllegro.fseek(master, 0, LibAllegro::SeekSet)

# Loop through the main file, opening a slice for each object
while slice = get_next_chunk(master)
  # Note: While the slice is open, we must avoid using the master file!
  # If you were dealing with packed images, this is where you would pass 'slice'
  # to LibAllegro.load_bitmap_f.

  if LibAllegro.fsize(slice) < BUFFER_SIZE
    # We could have used LibAllegro.fgets, but just to show that the file slice
    # is constrained to the string object, we'll read the entire slice.
    LibAllegro.fread(slice, buffer, LibAllegro.fsize(slice))
    buffer[LibAllegro.fsize(slice)] = 0u8
    log_printf("Chunk of size %d: '%s'\n", LibAllegro.fsize(slice).to_i, String.new(buffer))
  end

  # The slice must be closed before the next slice is opened. Closing
  # the slice will advanced the master file to the end of the slice.
  LibAllegro.fclose(slice)
end

LibAllegro.fclose(master)

LibAllegro.remove_filename(LibAllegro.path_cstr(tmp_path, '/'.ord))

close_log(true)
