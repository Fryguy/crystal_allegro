# Crystal port of ex_acodec.c from the Allegro examples.

# Ryan Dickie
# Audio example that loads a series of files and puts them through the mixer.
# Originlly derived from the audio example on the wiki.

require "../src/crystal_allegro"
require "./common"

include Common

class AbortException < Exception
end

begin
  if ARGV.size == 0
    n = 1
    filenames = ["data/welcome.wav"]
  else
    n = ARGV.size
    filenames = ARGV
  end

  abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

  open_log

  LibAllegro.init_acodec_addon

  abort_example("Could not init sound!\n") unless LibAllegro.install_audio

  voice = LibAllegro.create_voice(44100, LibAllegro::AudioDepth::AudioDepthInt16,
    LibAllegro::ChannelConf::ChannelConf2)
  abort_example("Could not create LibAllegro::Voice.\n") unless voice

  mixer = LibAllegro.create_mixer(44100, LibAllegro::AudioDepth::AudioDepthFloat32,
    LibAllegro::ChannelConf::ChannelConf2)
  abort_example("LibAllegro.create_mixer failed.\n") unless mixer

  if LibAllegro.attach_mixer_to_voice(mixer, voice) == 0
    abort_example("LibAllegro.attach_mixer_to_voice failed.\n")
  end

  sample = LibAllegro.create_sample_instance(nil)
  abort_example("LibAllegro.create_sample failed.\n") unless sample

  n.times do |i|
    filename = filenames[i]
    sample_time = 0.0

    # Load the entire sound file from disk.
    sample_data = LibAllegro.load_sample(filename)
    unless sample_data
      abort_example("Could not load sample from '%s'!\n",
        filename)
      next
    end

    if LibAllegro.set_sample(sample, sample_data) == 0
      abort_example("LibAllegro.set_sample_instance_ptr failed.\n")
      next
    end

    if LibAllegro.attach_sample_instance_to_mixer(sample, mixer) == 0
      abort_example("LibAllegro.attach_sample_instance_to_mixer failed.\n")
      raise AbortException.new
    end

    # Play sample in looping mode.
    LibAllegro.set_sample_instance_playmode(sample, LibAllegro::Playmode::PlaymodeLoop)
    LibAllegro.play_sample_instance(sample)

    sample_time = LibAllegro.get_sample_instance_time(sample)
    log_printf("Playing '%s' (%.3f seconds) 3 times", filename,
      sample_time)

    LibAllegro.rest(sample_time)

    if LibAllegro.set_sample_instance_gain(sample, 0.5) == 0
      abort_example("Failed to set gain.\n")
    end
    LibAllegro.rest(sample_time)

    if LibAllegro.set_sample_instance_gain(sample, 0.25) == 0
      abort_example("Failed to set gain.\n")
    end
    LibAllegro.rest(sample_time)

    LibAllegro.stop_sample_instance(sample)
    log_printf("\nDone playing '%s'\n", filename)

    # Free the memory allocated.
    LibAllegro.set_sample(sample, nil)
    LibAllegro.destroy_sample(sample_data)
  end

  LibAllegro.destroy_sample_instance(sample)
  LibAllegro.destroy_mixer(mixer)
  LibAllegro.destroy_voice(voice)

  LibAllegro.uninstall_audio
rescue AbortException
ensure
  close_log(true)
end
