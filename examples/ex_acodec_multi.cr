# Crystal port of ex_acodec_multi.c from the Allegro examples.

#
# Milan Mimica
# Audio example that plays multiple files at the same time
# Originlly derived from the ex_acodec example.
#

require "../src/crystal_allegro"
require "./common"

include Common

class AbortException < Exception
end

begin
  sample_data = [] of LibAllegro::Sample
  sample = [] of LibAllegro::SampleInstance

  abort_example("Could not init Allegro.\n") unless CrystalAllegro.init

  open_log

  if ARGV.size < 1
    log_printf("This example needs to be run from the command line.\nUsage: %s {audio_files}\n", $0)
    raise AbortException.new
  end

  LibAllegro.init_acodec_addon

  abort_example("Could not init sound!\n") unless LibAllegro.install_audio

  # a voice is used for playback
  voice = LibAllegro.create_voice(44100, LibAllegro::AudioDepth::AudioDepthInt16,
    LibAllegro::ChannelConf::ChannelConf2)
  abort_example("Could not create LibAllegro::Voice from sample\n") unless voice

  mixer = LibAllegro.create_mixer(44100, LibAllegro::AudioDepth::AudioDepthFloat32,
    LibAllegro::ChannelConf::ChannelConf2)
  abort_example("LibAllegro.create_mixer failed.\n") unless mixer

  if LibAllegro.attach_mixer_to_voice(mixer, voice) == 0
    abort_example("LibAllegro.attach_mixer_to_voice failed.\n")
  end

  ARGV.each_with_index do |filename, i|
    # loads the entire sound file from disk into sample data
    sample_data << LibAllegro.load_sample(filename)
    abort_example("Could not load sample from '%s'!\n", filename) unless sample_data[i]

    sample << LibAllegro.create_sample_instance(sample_data[i])
    unless sample[i]
      log_printf("Could not create sample!\n")
      LibAllegro.destroy_sample(sample_data[i])
      sample_data[i] = Pointer(Void).null.as(LibAllegro::Sample)
      next
    end

    if LibAllegro.attach_sample_instance_to_mixer(sample[i], mixer) == 0
      log_printf("LibAllegro.attach_sample_instance_to_mixer failed.\n")
      next
    end
  end

  longest_sample = 0.0

  ARGV.each_with_index do |filename, i|
    next unless sample[i]

    # play each sample once
    LibAllegro.play_sample_instance(sample[i])

    sample_time = LibAllegro.get_sample_instance_time(sample[i])
    log_printf("Playing '%s' (%.3f seconds)\n", filename, sample_time)

    longest_sample = sample_time if sample_time > longest_sample
  end

  LibAllegro.rest(longest_sample)

  log_printf("Done\n")

  ARGV.size.times do |i|
    # free the memory allocated when creating the sample + voice
    unless sample[i]
      LibAllegro.stop_sample_instance(sample[i])
      LibAllegro.destroy_sample_instance(sample[i])
      LibAllegro.destroy_sample(sample_data[i])
    end
  end
  LibAllegro.destroy_mixer(mixer)
  LibAllegro.destroy_voice(voice)

  sample = nil
  sample_data = nil

  LibAllegro.uninstall_audio
rescue AbortException
  close_log(true)
end
