require "./crystal_allegro/*"

module CrystalAllegro
  macro init
    LibAllegro.install_system(LibAllegro.get_allegro_version, nil)
  end

  macro malloc(p)
    LibAllegro.malloc_with_context({{p}}, __LINE__, __FILE__, nil)
  end

  macro free(p)
    LibAllegro.free_with_context({{p}}, __LINE__, __FILE__, nil)
  end
end

fun main(argc : Int32, argv : UInt8**) : Int32
  LibAllegro.run_main(argc, argv, ->Crystal.main)
end
