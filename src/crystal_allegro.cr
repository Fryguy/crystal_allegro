require "./crystal_allegro/*"

module CrystalAllegro
  @@main : Proc(Nil)?

  def self.run_main(&@@main)
    LibAllegro.run_main(0, nil, ->run_main_callback)
  end

  private def self.run_main_callback(_argc : LibC::Int, _argv : LibC::Char**) : LibC::Int
    @@main.not_nil!.call
    0
  rescue ex
    STDERR.puts ex.inspect_with_backtrace
    1
  end

  def self.init
    LibAllegro.install_system(LibAllegro.get_allegro_version, nil)
  end
end
