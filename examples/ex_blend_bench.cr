# Crystal port of ex_blend_bench.c from the Allegro examples.

# Benchmark for memory blenders.

require "../src/crystal_allegro"
require "./common"

lib LibC
  CLOCKS_PER_SEC = 1000000
  fun clock : ClockT
end

class ExBlendBench
  include Common

  # Do a few un-timed runs to switch CPU to performance mode and cache
  # data and so on - seems to make the results more stable here.
  # Also used to guess the number of timed iterations.
  WARMUP = 100
  # How many seconds the timing should approximately take - a fixed
  # number of iterations is not enough on very fast systems but takes
  # too long on slow systems.
  TEST_TIME = 5.0

  enum Mode
    All
    PlainBlit
    ScaledBlit
    RotateBlit
  end

  NAMES = [
    "", "Plain blit", "Scaled blit", "Rotated blit",
  ]

  property! display : Pointer(LibAllegro::Display)?

  def step(mode, b2)
    case mode
    when Mode::All
    when Mode::PlainBlit
      LibAllegro.draw_bitmap(b2, 0, 0, 0)
    when Mode::ScaledBlit
      LibAllegro.draw_scaled_bitmap(b2, 0, 0, 320, 200, 0, 0, 640, 480, 0)
    when Mode::RotateBlit
      LibAllegro.draw_scaled_rotated_bitmap(b2, 10, 10, 10, 10, 2.0, 2.0,
        LibAllegro::PI/30, 0)
    end
  end

  # LibAllegro.get_current_time measures wallclock time - but for the benchmark
  # result we prefer CPU time so clock is better.
  def current_clock
    c = LibC.clock
    c.to_f / LibC::CLOCKS_PER_SEC
  end

  def do_test(mode)
    state = uninitialized LibAllegro::State

    LibAllegro.set_new_bitmap_flags(LibAllegro::MemoryBitmap)

    b1 = LibAllegro.load_bitmap("data/mysha.pcx")
    unless b1
      abort_example("Error loading data/mysha.pcx\n")
      return false
    end

    b2 = LibAllegro.load_bitmap("data/allegro.pcx")
    unless b2
      abort_example("Error loading data/mysha.pcx\n")
      return false
    end

    LibAllegro.set_target_bitmap(b1)
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::InverseAlpha)
    step(mode, b2)

    # Display the blended bitmap to the screen so we can see something.
    LibAllegro.store_state(pointerof(state), LibAllegro::StateAll)
    LibAllegro.set_target_backbuffer(display)
    LibAllegro.set_blender(LibAllegro::Add, LibAllegro::One, LibAllegro::Zero)
    LibAllegro.draw_bitmap(b1, 0, 0, 0)
    LibAllegro.flip_display
    LibAllegro.restore_state(pointerof(state))

    log_printf("Benchmark: %s\n", NAMES[mode.value])
    log_printf("Please wait...\n")

    # Do warmup run and estimate required runs for real test.
    t0 = current_clock
    WARMUP.times do |i|
      step(mode, b2)
    end
    t1 = current_clock
    repeat = (TEST_TIME * 100 / (t1 - t0)).to_i

    # Do the real test.
    t0 = current_clock
    repeat.times do |i|
      step(mode, b2)
    end
    t1 = current_clock

    log_printf("Time = %g s, %d steps\n",
      t1 - t0, repeat)
    log_printf("%s: %g FPS\n", NAMES[mode.value], repeat / (t1 - t0))
    log_printf("Done\n")

    LibAllegro.destroy_bitmap(b1)
    LibAllegro.destroy_bitmap(b2)

    true
  end

  def main
    mode = Mode::All

    if ARGV.size >= 1
      i = ARGV[0].to_i
      case i
      when 0 then mode = Mode::PlainBlit
      when 1 then mode = Mode::ScaledBlit
      when 2 then mode = Mode::RotateBlit
      end
    end

    abort_example("Could not init Allegro\n") unless CrystalAllegro.init

    open_log

    LibAllegro.init_image_addon
    LibAllegro.init_primitives_addon
    init_platform_specific

    self.display = LibAllegro.create_display(640, 480)
    abort_example("Error creating display\n") unless display

    if mode == Mode::All
      # TODO: This should be a range, but Crystal does not yet support
      #   ranges on enums
      [Mode::PlainBlit, Mode::ScaledBlit, Mode::RotateBlit].each do |mode|
        do_test(mode)
      end
    else
      do_test(mode)
    end

    LibAllegro.destroy_display(display)

    close_log(true)
  end
end

ExBlendBench.new.main
