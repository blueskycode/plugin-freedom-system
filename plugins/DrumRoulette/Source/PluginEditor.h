#pragma once
#include "PluginProcessor.h"

class DrumRouletteAudioProcessorEditor : public juce::AudioProcessorEditor
{
public:
    explicit DrumRouletteAudioProcessorEditor(DrumRouletteAudioProcessor&);
    ~DrumRouletteAudioProcessorEditor() override;

    void paint(juce::Graphics&) override;
    void resized() override;

private:
    DrumRouletteAudioProcessor& processorRef;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DrumRouletteAudioProcessorEditor)
};
