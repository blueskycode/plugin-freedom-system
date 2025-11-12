#include "PluginProcessor.h"
#include "PluginEditor.h"

DrumRouletteAudioProcessor::DrumRouletteAudioProcessor()
    : AudioProcessor(BusesProperties()
                        .withOutput("Output", juce::AudioChannelSet::stereo(), true))
{
}

DrumRouletteAudioProcessor::~DrumRouletteAudioProcessor()
{
}

void DrumRouletteAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock)
{
    // Initialization will be added in Stage 4
    juce::ignoreUnused(sampleRate, samplesPerBlock);
}

void DrumRouletteAudioProcessor::releaseResources()
{
    // Cleanup will be added in Stage 4
}

void DrumRouletteAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    juce::ignoreUnused(midiMessages);

    // Pass-through for Stage 2 (DSP added in Stage 4)
    // Instrument needs to clear output buffer (no audio input to pass through)
    buffer.clear();
}

juce::AudioProcessorEditor* DrumRouletteAudioProcessor::createEditor()
{
    return new DrumRouletteAudioProcessorEditor(*this);
}

void DrumRouletteAudioProcessor::getStateInformation(juce::MemoryBlock& destData)
{
    // State management will be added in Stage 3
    juce::ignoreUnused(destData);
}

void DrumRouletteAudioProcessor::setStateInformation(const void* data, int sizeInBytes)
{
    // State management will be added in Stage 3
    juce::ignoreUnused(data, sizeInBytes);
}

// Factory function
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new DrumRouletteAudioProcessor();
}
