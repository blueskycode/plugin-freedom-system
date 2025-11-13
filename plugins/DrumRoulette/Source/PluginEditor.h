#pragma once
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_gui_basics/juce_gui_basics.h>
#include <juce_gui_extra/juce_gui_extra.h>
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

    // ========================================================================
    // RELAYS FIRST (no dependencies) - Pattern #11
    // ========================================================================

    // Slot 1 relays (8 parameters: 5 float + 3 bool)
    std::unique_ptr<juce::WebSliderRelay> relay_decay1;
    std::unique_ptr<juce::WebSliderRelay> relay_attack1;
    std::unique_ptr<juce::WebSliderRelay> relay_tiltFilter1;
    std::unique_ptr<juce::WebSliderRelay> relay_pitch1;
    std::unique_ptr<juce::WebSliderRelay> relay_volume1;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_solo1;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_mute1;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_lock1;

    // Slot 2 relays (8 parameters: 5 float + 3 bool)
    std::unique_ptr<juce::WebSliderRelay> relay_decay2;
    std::unique_ptr<juce::WebSliderRelay> relay_attack2;
    std::unique_ptr<juce::WebSliderRelay> relay_tiltFilter2;
    std::unique_ptr<juce::WebSliderRelay> relay_pitch2;
    std::unique_ptr<juce::WebSliderRelay> relay_volume2;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_solo2;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_mute2;
    std::unique_ptr<juce::WebToggleButtonRelay> relay_lock2;

    // ========================================================================
    // WEBVIEW SECOND (depends on relays) - Pattern #11
    // ========================================================================
    std::unique_ptr<juce::WebBrowserComponent> webView;

    // ========================================================================
    // ATTACHMENTS LAST (depend on both relays and webView) - Pattern #11
    // ========================================================================

    // Slot 1 attachments
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_decay1;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_attack1;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_tiltFilter1;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_pitch1;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_volume1;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_solo1;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_mute1;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_lock1;

    // Slot 2 attachments
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_decay2;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_attack2;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_tiltFilter2;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_pitch2;
    std::unique_ptr<juce::WebSliderParameterAttachment> attach_volume2;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_solo2;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_mute2;
    std::unique_ptr<juce::WebToggleButtonParameterAttachment> attach_lock2;

    // Helper for resource serving (Pattern #8 - explicit URL mapping)
    std::optional<juce::WebBrowserComponent::Resource> getResource(const juce::String& url);

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DrumRouletteAudioProcessorEditor)
};
