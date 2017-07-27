@[Include(
  "allegro5/allegro.h",
  "allegro5/allegro_image.h",
  prefix: %w(al_ AL_ ALLEGRO_ _ALLEGRO)
)]
@[Link("allegro")]
@[Link("allegro_image")]
{% if flag?(:darwin) %}
  @[Link(ldflags: "-L`xcode-select --print-path`/usr/lib")]
  @[Link(ldflags: "-rpath `xcode-select --print-path`/usr/lib")]
{% else %}
  @[Link(ldflags: "`llvm-config-3.6 --ldflags 2>/dev/null || llvm-config-3.5 --ldflags 2>/dev/null || llvm-config --ldflags 2>/dev/null`")]
{% end %}
lib LibAllegro
end
