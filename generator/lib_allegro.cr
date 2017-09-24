# How to generate
#
# ```
# git clone https://github.com/crystal-lang/crystal_lib.git
# cd crystal_allegro
# crystal ../crystal_lib/src/main.cr -- generator/lib_allegro.cr > src/crystal_allegro/lib_allegro.cr
# ```

@[Include(
  "allegro5/allegro.h",
  "allegro5/allegro_acodec.h",
  "allegro5/allegro_audio.h",
  "allegro5/allegro_color.h",
  "allegro5/allegro_image.h",
  "allegro5/allegro_font.h",
  "allegro5/allegro_native_dialog.h",
  "allegro5/allegro_primitives.h",

  prefix: %w(al_ AL_ ALLEGRO_ _al _ALLEGRO)
)]
@[Link("allegro")]
@[Link("allegro_acodec")]
@[Link("allegro_audio")]
@[Link("allegro_color")]
@[Link("allegro_dialog")]
@[Link("allegro_font")]
@[Link("allegro_image")]
@[Link("allegro_primitives")]
{% if flag?(:darwin) %}
  @[Link(ldflags: "-L`xcode-select --print-path`/usr/lib")]
  @[Link(ldflags: "-rpath `xcode-select --print-path`/usr/lib")]
{% else %}
  @[Link(ldflags: "`llvm-config-3.6 --ldflags 2>/dev/null || llvm-config-3.5 --ldflags 2>/dev/null || llvm-config --ldflags 2>/dev/null`")]
{% end %}
lib LibAllegro
end
