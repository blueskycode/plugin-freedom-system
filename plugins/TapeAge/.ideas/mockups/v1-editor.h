// TapeAge PluginEditor.h - C++ Header Boilerplate
// Generated from v1-ui.html mockup

#pragma once

#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_gui_extra/juce_gui_extra.h>

class TapeAgeAudioProcessor;

class TapeAgeAudioProcessorEditor : public juce::AudioProcessorEditor
{
public:
    TapeAgeAudioProcessorEditor(TapeAgeAudioProcessor&);
    ~TapeAgeAudioProcessorEditor() override;

    void paint(juce::Graphics&) override;
    void resized() override;

private:
    TapeAgeAudioProcessor& audioProcessor;

    // CRITICAL ORDER: Relays FIRST, WebView SECOND, Attachments LAST

    // 1. RELAYS FIRST (no dependencies)
    juce::WebSliderRelay driveRelay;
    juce::WebSliderRelay ageRelay;
    juce::WebSliderRelay mixRelay;

    // 2. WEBVIEW SECOND (depends on relays)
    juce::WebBrowserComponent webView;

    // 3. ATTACHMENTS LAST (depend on both relays and parameters)
    std::unique_ptr<juce::WebSliderParameterAttachment> driveAttachment;
    std::unique_ptr<juce::WebSliderParameterAttachment> ageAttachment;
    std::unique_ptr<juce::WebSliderParameterAttachment> mixAttachment;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(TapeAgeAudioProcessorEditor)
};
