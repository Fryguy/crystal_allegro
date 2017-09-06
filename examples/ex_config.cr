# Crystal port of ex_config.c from the Allegro examples.

# Example program for the Allegro library.
#
# Test config file reading and writing.

require "../src/crystal_allegro"
require "./common"

include Common

passed = true

macro test(name, expr)
  if {{expr}}
    log_printf(" PASS - %s\n", {{name}})
  else
    log_printf("!FAIL - %s\n", {{name}})
    passed = false
  end
end

iterator = uninitialized LibAllegro::ConfigSection
iterator2 = uninitialized LibAllegro::ConfigEntry

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init
open_log

cfg = LibAllegro.load_config_file("data/sample.cfg")
abort_example("Couldn't load data/sample.cfg\n") unless cfg

value = LibAllegro.get_config_value(cfg, nil, "old_var")
test("global var", String.new(value) == "old global value")

value = LibAllegro.get_config_value(cfg, "section", "old_var")
test("section var", String.new(value) == "old section value")

value = LibAllegro.get_config_value(cfg, "", "mysha.xpm")
test("long value", String.new(value).size == 1394)

# Test removing.
LibAllegro.set_config_value(cfg, "empty", "key_remove", "to be removed")
LibAllegro.remove_config_key(cfg, "empty", "key_remove")

LibAllegro.set_config_value(cfg, "schrödinger", "box", "cat")
LibAllegro.remove_config_section(cfg, "schrödinger")

# Test whether iterating through our whole sample.cfg returns all
# sections and entries, in order.

value = LibAllegro.get_first_config_section(cfg, pointerof(iterator))
test("section1", String.new(value) == "")

value = LibAllegro.get_first_config_entry(cfg, value, pointerof(iterator2))
test("entry1", String.new(value) == "old_var")

value = LibAllegro.get_next_config_entry(pointerof(iterator2))
test("entry2", String.new(value) == "mysha.xpm")

value = LibAllegro.get_next_config_entry(pointerof(iterator2))
test("entry3", value.null?)

value = LibAllegro.get_next_config_section(pointerof(iterator))
test("section2", String.new(value) == "section")

value = LibAllegro.get_first_config_entry(cfg, value, pointerof(iterator2))
test("entry4", String.new(value) == "old_var")

value = LibAllegro.get_next_config_entry(pointerof(iterator2))
test("entry5", value.null?)

value = LibAllegro.get_next_config_section(pointerof(iterator))
test("section3", value)

value = LibAllegro.get_first_config_entry(cfg, value, pointerof(iterator2))
test("entry6", value)

value = LibAllegro.get_next_config_entry(pointerof(iterator2))
test("entry7", value.null?)

value = LibAllegro.get_next_config_section(pointerof(iterator))
test("empty", String.new(value) == "empty")

value = LibAllegro.get_first_config_entry(cfg, value, pointerof(iterator2))
test("empty entry", value.null?)

value = LibAllegro.get_next_config_section(pointerof(iterator))
test("section4", value.null?)

LibAllegro.set_config_value(cfg, "", "new_var", "new value")
LibAllegro.set_config_value(cfg, "section", "old_var", "new value")

test("save_config", LibAllegro.save_config_file("test.cfg", cfg))

log_printf("Done\n")

LibAllegro.destroy_config(cfg)

close_log(true)

exit 1 unless passed
