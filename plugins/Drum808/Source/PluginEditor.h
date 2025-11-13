#pragma once
#include <JuceHeader.h>
#include "PluginProcessor.h"

class Drum808AudioProcessorEditor : public juce::AudioProcessorEditor
{
public:
    explicit Drum808AudioProcessorEditor(Drum808AudioProcessor&);
    ~Drum808AudioProcessorEditor() override;

    void paint(juce::Graphics&) override;
    void resized() override;

private:
    Drum808AudioProcessor& processorRef;

    // WebView component (use std::unique_ptr per Pattern 11)
    std::unique_ptr<juce::WebBrowserComponent> webView;

    // Resource provider
    std::optional<juce::WebBrowserComponent::Resource> getResource(const juce::String& url);

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(Drum808AudioProcessorEditor)
};
