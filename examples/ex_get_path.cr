# Crystal port of ex_get_path.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

def show_path(id, label)
  path = LibAllegro.get_standard_path(id)
  path_str = path ? String.new(LibAllegro.path_cstr(path, LibAllegro::NativePathSep)) : "<none>"
  log_printf("%s: %s\n", label, path_str)
  LibAllegro.destroy_path(path)
end

# defaults to blank
LibAllegro.set_org_name("liballeg.org")

# defaults to the exename, set it here to remove the .exe on windows
LibAllegro.set_app_name("ex_get_path")

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init
open_log

(1..3).each do |pass|
  case pass
  when 1
    log_printf("With default exe name:\n")
  when 2
    log_printf("\nOverriding exe name to blahblah\n")
    LibAllegro.set_exe_name("blahblah")
  when 3
    log_printf("\nOverriding exe name to /tmp/blahblah.exe:\n")
    LibAllegro.set_exe_name("/tmp/blahblah.exe")
  end

  show_path(LibAllegro::ResourcesPath, "RESOURCES_PATH")
  show_path(LibAllegro::TempPath, "TEMP_PATH")
  show_path(LibAllegro::UserDataPath, "USER_DATA_PATH")
  show_path(LibAllegro::UserSettingsPath, "USER_SETTINGS_PATH")
  show_path(LibAllegro::UserHomePath, "USER_HOME_PATH")
  show_path(LibAllegro::UserDocumentsPath, "USER_DOCUMENTS_PATH")
  show_path(LibAllegro::ExenamePath, "EXENAME_PATH")
end

close_log(true)
