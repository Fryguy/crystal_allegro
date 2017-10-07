# CrystalAllegro

CrystalAllegro is a Crystal binding to the [Allegro](http://liballeg.org/) game programming library.

## Installation

- [Install Allegro](https://wiki.allegro.cc/index.php?title=Getting_Started#Installing_Allegro)
- Install the Crystal shard

  Add this to your application's `shard.yml`:

  ```yaml
  dependencies:
    crystal_allegro:
      github: Fryguy/crystal_allegro
  ```

## Usage

Start your application by calling CrystalAllegro.init:

```crystal
require "crystal_allegro"

raise "Cannot initialize Crystal" unless CrystalAllegro.init
```

After that, it's up to you!  For the Allegro API reference, go [here](http://liballeg.org/a5docs/trunk/).
See the [examples](examples) directory for Crystal ports of the Allegro examples.

## Development

`src/crystal_allegro/lib_allegro.cr` is generated using
[crystal_lib](https://github.com/crystal-lang/crystal_lib). To regenerate it:

```sh
git clone https://github.com/crystal-lang/crystal_lib.git
cd crystal_allegro
crystal ../crystal_lib/src/main.cr -- generator/lib_allegro.cr > src/crystal_allegro/lib_allegro.cr
```

## Contributing

1. Fork it ( https://github.com/Fryguy/crystal_allegro/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).  See [LICENSE](LICENSE).

### Third Party Licenses

The files in examples/data are borrowed from the Allegro source in order to allow the Crystal examples to serve as a mirror of the original examples. As such, the Allegro license is also included in [LICENSE_ALLEGRO](LICENSE_ALLEGRO).
