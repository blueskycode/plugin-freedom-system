#include "PluginProcessor.h"
#include "PluginEditor.h"

// Parameter layout creation (BEFORE constructor)
juce::AudioProcessorValueTreeState::ParameterLayout Drum808AudioProcessor::createParameterLayout()
{
    juce::AudioProcessorValueTreeState::ParameterLayout layout;

    // KICK (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "kick_level", 1 },
        "Kick Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        80.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "kick_tone", 1 },
        "Kick Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        50.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "kick_decay", 1 },
        "Kick Decay",
        juce::NormalisableRange<float>(50.0f, 1000.0f, 1.0f),
        400.0f,
        "ms"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "kick_tuning", 1 },
        "Kick Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        0.0f,
        "st"
    ));

    // LOW TOM (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "lowtom_level", 1 },
        "Low Tom Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        75.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "lowtom_tone", 1 },
        "Low Tom Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        50.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "lowtom_decay", 1 },
        "Low Tom Decay",
        juce::NormalisableRange<float>(50.0f, 1000.0f, 1.0f),
        300.0f,
        "ms"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "lowtom_tuning", 1 },
        "Low Tom Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        0.0f,
        "st"
    ));

    // MID TOM (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "midtom_level", 1 },
        "Mid Tom Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        75.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "midtom_tone", 1 },
        "Mid Tom Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        50.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "midtom_decay", 1 },
        "Mid Tom Decay",
        juce::NormalisableRange<float>(50.0f, 1000.0f, 1.0f),
        250.0f,
        "ms"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "midtom_tuning", 1 },
        "Mid Tom Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        5.0f,
        "st"
    ));

    // CLAP (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "clap_level", 1 },
        "Clap Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        70.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "clap_tone", 1 },
        "Clap Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        50.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "clap_snap", 1 },
        "Clap Snap",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        60.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "clap_tuning", 1 },
        "Clap Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        0.0f,
        "st"
    ));

    // CLOSED HAT (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "closedhat_level", 1 },
        "Closed Hat Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        65.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "closedhat_tone", 1 },
        "Closed Hat Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        60.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "closedhat_decay", 1 },
        "Closed Hat Decay",
        juce::NormalisableRange<float>(20.0f, 200.0f, 1.0f),
        80.0f,
        "ms"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "closedhat_tuning", 1 },
        "Closed Hat Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        0.0f,
        "st"
    ));

    // OPEN HAT (4 parameters)
    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "openhat_level", 1 },
        "Open Hat Level",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        60.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "openhat_tone", 1 },
        "Open Hat Tone",
        juce::NormalisableRange<float>(0.0f, 100.0f, 0.1f),
        60.0f,
        "%"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "openhat_decay", 1 },
        "Open Hat Decay",
        juce::NormalisableRange<float>(100.0f, 1000.0f, 1.0f),
        500.0f,
        "ms"
    ));

    layout.add(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID { "openhat_tuning", 1 },
        "Open Hat Tuning",
        juce::NormalisableRange<float>(-12.0f, 12.0f, 0.1f),
        0.0f,
        "st"
    ));

    return layout;
}

Drum808AudioProcessor::Drum808AudioProcessor()
    : AudioProcessor(BusesProperties()
                        .withOutput("Main", juce::AudioChannelSet::stereo(), true)
                        .withOutput("Kick", juce::AudioChannelSet::stereo(), false)
                        .withOutput("Low Tom", juce::AudioChannelSet::stereo(), false)
                        .withOutput("Mid Tom", juce::AudioChannelSet::stereo(), false)
                        .withOutput("Clap", juce::AudioChannelSet::stereo(), false)
                        .withOutput("Closed Hat", juce::AudioChannelSet::stereo(), false)
                        .withOutput("Open Hat", juce::AudioChannelSet::stereo(), false))
    , parameters(*this, nullptr, "Parameters", createParameterLayout())
{
}

Drum808AudioProcessor::~Drum808AudioProcessor()
{
}

void Drum808AudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock)
{
    currentSampleRate = sampleRate;

    // Prepare DSP spec
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = static_cast<juce::uint32>(samplesPerBlock);
    spec.numChannels = static_cast<juce::uint32>(getTotalNumOutputChannels());

    // Configure and prepare Low Tom
    lowTom.oscillator.initialise([](float x) { return std::sin(x); }); // Sine wave
    lowTom.oscillator.prepare(spec);
    lowTom.filter.prepare(spec);
    lowTom.filter.setType(juce::dsp::StateVariableTPTFilterType::bandpass);
    lowTom.filter.setResonance(0.5f); // Initial Q (will be updated per-sample)
    lowTom.oscillator.reset();
    lowTom.filter.reset();

    // Configure and prepare Mid Tom
    midTom.oscillator.initialise([](float x) { return std::sin(x); }); // Sine wave
    midTom.oscillator.prepare(spec);
    midTom.filter.prepare(spec);
    midTom.filter.setType(juce::dsp::StateVariableTPTFilterType::bandpass);
    midTom.filter.setResonance(0.5f); // Initial Q (will be updated per-sample)
    midTom.oscillator.reset();
    midTom.filter.reset();
}

void Drum808AudioProcessor::releaseResources()
{
    // Cleanup will be added in Stage 3
}

void Drum808AudioProcessor::processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;

    // Clear all output buses
    buffer.clear();

    const int numSamples = buffer.getNumSamples();

    // Read tom parameters (atomic, real-time safe)
    auto* lowTomLevelParam = parameters.getRawParameterValue("lowtom_level");
    auto* lowTomToneParam = parameters.getRawParameterValue("lowtom_tone");
    auto* lowTomDecayParam = parameters.getRawParameterValue("lowtom_decay");
    auto* lowTomTuningParam = parameters.getRawParameterValue("lowtom_tuning");

    auto* midTomLevelParam = parameters.getRawParameterValue("midtom_level");
    auto* midTomToneParam = parameters.getRawParameterValue("midtom_tone");
    auto* midTomDecayParam = parameters.getRawParameterValue("midtom_decay");
    auto* midTomTuningParam = parameters.getRawParameterValue("midtom_tuning");

    float lowTomLevel = lowTomLevelParam->load() / 100.0f; // 0-100% → 0.0-1.0
    float lowTomTone = lowTomToneParam->load() / 100.0f;
    float lowTomDecay = lowTomDecayParam->load() / 1000.0f; // ms → seconds
    float lowTomTuning = lowTomTuningParam->load(); // semitones

    float midTomLevel = midTomLevelParam->load() / 100.0f;
    float midTomTone = midTomToneParam->load() / 100.0f;
    float midTomDecay = midTomDecayParam->load() / 1000.0f;
    float midTomTuning = midTomTuningParam->load();

    // Calculate tuned base frequencies
    const float lowTomBaseFreq = 150.0f * std::pow(2.0f, lowTomTuning / 12.0f);
    const float midTomBaseFreq = 220.0f * std::pow(2.0f, midTomTuning / 12.0f);

    // Map tone parameter to filter Q (0.5 to 5.0)
    const float lowTomQ = 0.5f + (lowTomTone * 4.5f);
    const float midTomQ = 0.5f + (midTomTone * 4.5f);

    // Process MIDI messages
    for (const auto metadata : midiMessages)
    {
        auto message = metadata.getMessage();

        if (message.isNoteOn())
        {
            int note = message.getNoteNumber();
            float velocity = message.getVelocity() / 127.0f;

            // Map MIDI notes to voices
            if (note == 41) // F1 → Low Tom
            {
                lowTom.trigger(velocity, lowTomBaseFreq);
            }
            else if (note == 45) // A1 → Mid Tom
            {
                midTom.trigger(velocity, midTomBaseFreq);
            }
        }
    }

    // Synthesize voices (per-sample processing)
    for (int sample = 0; sample < numSamples; ++sample)
    {
        float lowTomSample = 0.0f;
        float midTomSample = 0.0f;

        // Low Tom synthesis
        if (lowTom.isPlaying)
        {
            // Update filter Q
            lowTom.filter.setCutoffFrequency(lowTomBaseFreq);
            lowTom.filter.setResonance(lowTomQ);

            // Generate oscillator sample
            float oscSample = lowTom.oscillator.processSample(0.0f);

            // Apply filter
            float filteredSample = lowTom.filter.processSample(0, oscSample);

            // Exponential envelope
            float envelope = std::exp(-lowTom.envelopeTime / lowTomDecay);

            // Denormal protection
            if (envelope < 1e-8f)
            {
                lowTom.stop();
                envelope = 0.0f;
            }

            // Apply envelope, velocity, and level
            lowTomSample = filteredSample * envelope * lowTom.velocity * lowTomLevel;

            // Advance envelope time
            lowTom.envelopeTime += 1.0f / static_cast<float>(currentSampleRate);
        }

        // Mid Tom synthesis
        if (midTom.isPlaying)
        {
            // Update filter Q
            midTom.filter.setCutoffFrequency(midTomBaseFreq);
            midTom.filter.setResonance(midTomQ);

            // Generate oscillator sample
            float oscSample = midTom.oscillator.processSample(0.0f);

            // Apply filter
            float filteredSample = midTom.filter.processSample(0, oscSample);

            // Exponential envelope
            float envelope = std::exp(-midTom.envelopeTime / midTomDecay);

            // Denormal protection
            if (envelope < 1e-8f)
            {
                midTom.stop();
                envelope = 0.0f;
            }

            // Apply envelope, velocity, and level
            midTomSample = filteredSample * envelope * midTom.velocity * midTomLevel;

            // Advance envelope time
            midTom.envelopeTime += 1.0f / static_cast<float>(currentSampleRate);
        }

        // Write to output buses
        // Main mix (bus 0, stereo)
        if (buffer.getNumChannels() >= 2)
        {
            buffer.addSample(0, sample, lowTomSample + midTomSample); // Left
            buffer.addSample(1, sample, lowTomSample + midTomSample); // Right
        }

        // Individual outputs (if enabled by DAW)
        // Low Tom output (bus 2, channels 4-5)
        if (buffer.getNumChannels() >= 6)
        {
            buffer.addSample(4, sample, lowTomSample); // Low Tom Left
            buffer.addSample(5, sample, lowTomSample); // Low Tom Right
        }

        // Mid Tom output (bus 3, channels 6-7)
        if (buffer.getNumChannels() >= 8)
        {
            buffer.addSample(6, sample, midTomSample); // Mid Tom Left
            buffer.addSample(7, sample, midTomSample); // Mid Tom Right
        }
    }
}

juce::AudioProcessorEditor* Drum808AudioProcessor::createEditor()
{
    return new Drum808AudioProcessorEditor(*this);
}

void Drum808AudioProcessor::getStateInformation(juce::MemoryBlock& destData)
{
    auto state = parameters.copyState();
    std::unique_ptr<juce::XmlElement> xml(state.createXml());
    copyXmlToBinary(*xml, destData);
}

void Drum808AudioProcessor::setStateInformation(const void* data, int sizeInBytes)
{
    std::unique_ptr<juce::XmlElement> xmlState(getXmlFromBinary(data, sizeInBytes));

    if (xmlState != nullptr && xmlState->hasTagName(parameters.state.getType()))
        parameters.replaceState(juce::ValueTree::fromXml(*xmlState));
}

// Factory function
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new Drum808AudioProcessor();
}
