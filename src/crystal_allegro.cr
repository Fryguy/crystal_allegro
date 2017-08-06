require "./crystal_allegro/*"

module CrystalAllegro
  def self.init
    LibAllegro.install_system(LibAllegro.get_allegro_version, nil)
  end
end

# Temporary copy of redefine_main until https://github.com/crystal-lang/crystal/pull/4798 is merged
macro redefine_main(name = main, alt_name = main)
  # :nodoc:
  fun {{alt_name.id}} = {{name.id}}(argc : Int32, argv : UInt8**) : Int32
    %ex = nil
    %status = begin
      GC.init
      {{yield LibCrystalMain.__crystal_main(argc, argv)}}
      0
    rescue ex
      %ex = ex
      1
    end

    AtExitHandlers.run %status
    %ex.inspect_with_backtrace STDERR if %ex
    STDOUT.flush
    STDERR.flush
    %status
  end
end

redefine_main(crystal_main, crystal_main) do |main|
  {{main}}
end

fun main(argc : Int32, argv : UInt8**) : Int32
  LibAllegro.run_main(argc, argv, ->crystal_main)
end
