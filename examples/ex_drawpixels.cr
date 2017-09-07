# Crystal port of ex_draw_pixels.c from the Allegro examples.

require "../src/crystal_allegro"
require "./common"

include Common

WIDTH      =  640
HEIGHT     =  480
NUM_STARS  =  300
TARGET_FPS = 9999

class Point
  property x = 0.0
  property y = 0.0
end

key_state = uninitialized LibAllegro::KeyboardState
stars = Array.new(3) { Array.new(NUM_STARS / 3) { Point.new } }
speeds = [0.0001, 0.05, 0.15]
colors = [] of LibAllegro::Color
total_frames = 0

abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

open_log

LibAllegro.install_keyboard

display = LibAllegro.create_display(WIDTH, HEIGHT)
abort_example("Could not create display.\n") unless display

colors << LibAllegro.map_rgba(255, 100, 255, 128)
colors << LibAllegro.map_rgba(255, 100, 100, 255)
colors << LibAllegro.map_rgba(100, 100, 255, 255)

3.times do |layer|
  (NUM_STARS / 3).times do |star|
    p = stars[layer][star]
    p.x = rand(WIDTH).to_f
    p.y = rand(HEIGHT).to_f
  end
end

start = (LibAllegro.get_time * 1000).to_i
now = start
elapsed = 0
frame_count = 0
program_start = LibAllegro.get_time

loop do
  if frame_count < (1000 / TARGET_FPS)
    frame_count += elapsed
  else
    frame_count -= (1000 / TARGET_FPS)
    LibAllegro.clear_to_color(LibAllegro.map_rgb(0, 0, 0))
    (NUM_STARS / 3).times do |star|
      p = stars[0][star]
      LibAllegro.draw_pixel(p.x, p.y, colors[0])
    end
    LibAllegro.lock_bitmap(LibAllegro.get_backbuffer(display), LibAllegro::PixelFormatAny, 0)

    3.times do |layer|
      (NUM_STARS / 3).times do |star|
        p = stars[layer][star]
        # put_pixel ignores blending
        LibAllegro.put_pixel(p.x, p.y, colors[layer])
      end
    end

    # Check that dots appear at the window extremes.
    x = WIDTH - 1
    y = HEIGHT - 1
    LibAllegro.put_pixel(0, 0, LibAllegro.map_rgb_f(1, 1, 1))
    LibAllegro.put_pixel(x, 0, LibAllegro.map_rgb_f(1, 1, 1))
    LibAllegro.put_pixel(0, y, LibAllegro.map_rgb_f(1, 1, 1))
    LibAllegro.put_pixel(x, y, LibAllegro.map_rgb_f(1, 1, 1))

    LibAllegro.unlock_bitmap(LibAllegro.get_backbuffer(display))
    LibAllegro.flip_display
    total_frames += 1
  end

  now = (LibAllegro.get_time * 1000).to_i
  elapsed = now - start
  start = now

  3.times do |layer|
    (NUM_STARS / 3).times do |star|
      p = stars[layer][star]
      p.y -= speeds[layer] * elapsed
      if p.y < 0
        p.x = rand(WIDTH).to_f
        p.y = HEIGHT.to_f
      end
    end
  end

  LibAllegro.rest(0.001)

  LibAllegro.get_keyboard_state(pointerof(key_state))
  break if LibAllegro.key_down(pointerof(key_state), LibAllegro::KeyEscape) != 0
end

length = LibAllegro.get_time - program_start

if length != 0
  log_printf("%d FPS\n", (total_frames / length).to_i)
end

LibAllegro.destroy_display(display)

close_log(true)
