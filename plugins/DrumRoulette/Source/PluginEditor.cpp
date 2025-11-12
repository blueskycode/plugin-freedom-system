#include "PluginEditor.h"

DrumRouletteAudioProcessorEditor::DrumRouletteAudioProcessorEditor(DrumRouletteAudioProcessor& p)
    : AudioProcessorEditor(&p), processorRef(p)
{
    setSize(1400, 950);
}

DrumRouletteAudioProcessorEditor::~DrumRouletteAudioProcessorEditor()
{
}

void DrumRouletteAudioProcessorEditor::paint(juce::Graphics& g)
{
    g.fillAll(getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));

    g.setColour(juce::Colours::white);
    g.setFont(24.0f);
    g.drawFittedText("DrumRoulette - Stage 2", getLocalBounds(), juce::Justification::centred, 1);
}

void DrumRouletteAudioProcessorEditor::resized()
{
    // Layout will be added in Stage 5
}
