# Crystal port of ex_dir.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

def print_file(entry)
  mode = LibAllegro.get_fs_entry_mode(entry)
  now = Time.now.epoch
  atime = LibAllegro.get_fs_entry_atime(entry)
  ctime = LibAllegro.get_fs_entry_ctime(entry)
  mtime = LibAllegro.get_fs_entry_mtime(entry)
  size = LibAllegro.get_fs_entry_size(entry)
  name = LibAllegro.get_fs_entry_name(entry)

  log_printf("%-36s %s%s%s%s%s%s %8d %8d %8d %8d\n",
    String.new(name),
    mode & LibAllegro::FilemodeRead != 0 ? "r" : ".",
    mode & LibAllegro::FilemodeWrite != 0 ? "w" : ".",
    mode & LibAllegro::FilemodeExecute != 0 ? "x" : ".",
    mode & LibAllegro::FilemodeHidden != 0 ? "h" : ".",
    mode & LibAllegro::FilemodeIsfile != 0 ? "f" : ".",
    mode & LibAllegro::FilemodeIsdir != 0 ? "d" : ".",
    now - ctime,
    now - mtime,
    now - atime,
    size)
end

def print_entry(entry)
  print_file(entry)

  return if LibAllegro.get_fs_entry_mode(entry) & LibAllegro::FilemodeIsdir != 0

  if LibAllegro.open_directory(entry) != 0
    log_printf("Error opening directory: %s\n", LibAllegro.get_fs_entry_name(entry))
    return
  end

  loop do
    next_dir = LibAllegro.read_directory(entry)
    break unless next_dir

    print_entry(next_dir)
    LibAllegro.destroy_fs_entry(next_dir)
  end

  LibAllegro.close_directory(entry)
end

def print_fs_entry_cb(entry, extra)
  print_file(entry)
  return LibAllegro::ForEachFsEntryOk
end

def print_fs_entry_cb_norecurse(entry, extra)
  print_file(entry)
  return LibAllegro::ForEachFsEntrySkip
end

def print_fs_entry(dir)
  log_printf("\n------------------------------------\nExample of LibAllegro.for_each_fs_entry with recursion:\n\n")
  LibAllegro.for_each_fs_entry(dir, ->print_fs_entry_cb,
    LibAllegro.get_fs_entry_name(dir))
end

def print_fs_entry_norecurse(dir)
  log_printf("\n------------------------------------\nExample of LibAllegro.for_each_fs_entry without recursion:\n\n")
  LibAllegro.for_each_fs_entry(dir, ->print_fs_entry_cb_norecurse,
    LibAllegro.get_fs_entry_name(dir))
end

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init
open_log_monospace

log_printf("Example of filesystem entry functions:\n\n%-36s %-6s %8s %8s %8s %8s\n",
  "name", "flags", "ctime", "mtime", "atime", "size")
log_printf(
  "------------------------------------ " \
  "------ " \
  "-------- " \
  "-------- " \
  "-------- " \
  "--------\n")

# {{ if flags?(:android) }}
# LibAllegro.android_set_apk_fs_interface
# {{ end }}

if ARGV.size == 0
  entry = LibAllegro.create_fs_entry("data")
  print_entry(entry)
  print_fs_entry(entry)
  print_fs_entry_norecurse(entry)
  LibAllegro.destroy_fs_entry(entry)
end

ARGV.each do |argv|
  entry = LibAllegro.create_fs_entry(argv)
  print_entry(entry)
  print_fs_entry(entry)
  print_fs_entry_norecurse(entry)
  LibAllegro.destroy_fs_entry(entry)
end

close_log(true)
