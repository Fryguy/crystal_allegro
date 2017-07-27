require "./crystal_allegro/*"

module CrystalAllegro
  @@real_main : Proc(Int32, Array(String), Nil)?

  def self.run_main(@@real_main)
    LibAllegro.run_main(0, nil, ->run_main_callback)
  end

  def self.run_main_callback(argc : LibC::Int, argv : LibC::Char**) : LibC::Int
    @@real_main.not_nil!.call(ARGV.size + 1, ARGV.unshift($0))
    0
  rescue ex
    STDERR.puts ex.inspect_with_backtrace
    1
  end

  def self.init
    LibAllegro.install_system(LibAllegro.get_allegro_version, nil)
  end
end
