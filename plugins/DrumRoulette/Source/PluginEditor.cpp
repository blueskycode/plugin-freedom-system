#include "PluginEditor.h"
#include "BinaryData.h"

DrumRouletteAudioProcessorEditor::DrumRouletteAudioProcessorEditor(DrumRouletteAudioProcessor& p)
    : AudioProcessorEditor(&p), processorRef(p)
{
    // ========================================================================
    // STEP 1: Create relays FIRST (Pattern #11)
    // ========================================================================

    // Slot 1 relays (8 parameters)
    relay_decay1 = std::make_unique<juce::WebSliderRelay>("DECAY_1");
    relay_attack1 = std::make_unique<juce::WebSliderRelay>("ATTACK_1");
    relay_tiltFilter1 = std::make_unique<juce::WebSliderRelay>("TILT_FILTER_1");
    relay_pitch1 = std::make_unique<juce::WebSliderRelay>("PITCH_1");
    relay_volume1 = std::make_unique<juce::WebSliderRelay>("VOLUME_1");
    relay_solo1 = std::make_unique<juce::WebToggleButtonRelay>("SOLO_1");  // Pattern #19
    relay_mute1 = std::make_unique<juce::WebToggleButtonRelay>("MUTE_1");  // Pattern #19
    relay_lock1 = std::make_unique<juce::WebToggleButtonRelay>("LOCK_1");  // Pattern #19

    // Slot 2 relays (8 parameters)
    relay_decay2 = std::make_unique<juce::WebSliderRelay>("DECAY_2");
    relay_attack2 = std::make_unique<juce::WebSliderRelay>("ATTACK_2");
    relay_tiltFilter2 = std::make_unique<juce::WebSliderRelay>("TILT_FILTER_2");
    relay_pitch2 = std::make_unique<juce::WebSliderRelay>("PITCH_2");
    relay_volume2 = std::make_unique<juce::WebSliderRelay>("VOLUME_2");
    relay_solo2 = std::make_unique<juce::WebToggleButtonRelay>("SOLO_2");  // Pattern #19
    relay_mute2 = std::make_unique<juce::WebToggleButtonRelay>("MUTE_2");  // Pattern #19
    relay_lock2 = std::make_unique<juce::WebToggleButtonRelay>("LOCK_2");  // Pattern #19

    // ========================================================================
    // STEP 2: Create WebView SECOND with relay options (Pattern #11)
    // ========================================================================
    webView = std::make_unique<juce::WebBrowserComponent>(
        juce::WebBrowserComponent::Options{}
            .withNativeIntegrationEnabled()  // CRITICAL: Enables JUCE JavaScript library
            .withKeepPageLoadedWhenBrowserIsHidden()
            .withResourceProvider([this](const juce::String& url) { return getResource(url); })
            // Register all relays (slot 1)
            .withOptionsFrom(*relay_decay1)
            .withOptionsFrom(*relay_attack1)
            .withOptionsFrom(*relay_tiltFilter1)
            .withOptionsFrom(*relay_pitch1)
            .withOptionsFrom(*relay_volume1)
            .withOptionsFrom(*relay_solo1)
            .withOptionsFrom(*relay_mute1)
            .withOptionsFrom(*relay_lock1)
            // Register all relays (slot 2)
            .withOptionsFrom(*relay_decay2)
            .withOptionsFrom(*relay_attack2)
            .withOptionsFrom(*relay_tiltFilter2)
            .withOptionsFrom(*relay_pitch2)
            .withOptionsFrom(*relay_volume2)
            .withOptionsFrom(*relay_solo2)
            .withOptionsFrom(*relay_mute2)
            .withOptionsFrom(*relay_lock2)
    );

    // ========================================================================
    // STEP 3: Create attachments LAST (Pattern #11, #12)
    // ========================================================================

    // Slot 1 attachments (Pattern #12: 3 parameters - parameter, relay, nullptr)
    attach_decay1 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("DECAY_1"), *relay_decay1, nullptr);
    attach_attack1 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("ATTACK_1"), *relay_attack1, nullptr);
    attach_tiltFilter1 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("TILT_FILTER_1"), *relay_tiltFilter1, nullptr);
    attach_pitch1 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("PITCH_1"), *relay_pitch1, nullptr);
    attach_volume1 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("VOLUME_1"), *relay_volume1, nullptr);
    attach_solo1 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("SOLO_1"), *relay_solo1, nullptr);
    attach_mute1 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("MUTE_1"), *relay_mute1, nullptr);
    attach_lock1 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("LOCK_1"), *relay_lock1, nullptr);

    // Slot 2 attachments
    attach_decay2 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("DECAY_2"), *relay_decay2, nullptr);
    attach_attack2 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("ATTACK_2"), *relay_attack2, nullptr);
    attach_tiltFilter2 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("TILT_FILTER_2"), *relay_tiltFilter2, nullptr);
    attach_pitch2 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("PITCH_2"), *relay_pitch2, nullptr);
    attach_volume2 = std::make_unique<juce::WebSliderParameterAttachment>(
        *processorRef.parameters.getParameter("VOLUME_2"), *relay_volume2, nullptr);
    attach_solo2 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("SOLO_2"), *relay_solo2, nullptr);
    attach_mute2 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("MUTE_2"), *relay_mute2, nullptr);
    attach_lock2 = std::make_unique<juce::WebToggleButtonParameterAttachment>(
        *processorRef.parameters.getParameter("LOCK_2"), *relay_lock2, nullptr);

    addAndMakeVisible(*webView);
    webView->goToURL(juce::WebBrowserComponent::getResourceProviderRoot());

    setSize(1400, 950);  // From v4-ui.yaml
}

DrumRouletteAudioProcessorEditor::~DrumRouletteAudioProcessorEditor() = default;

void DrumRouletteAudioProcessorEditor::paint(juce::Graphics& g)
{
    // WebView handles all painting
    juce::ignoreUnused(g);
}

void DrumRouletteAudioProcessorEditor::resized()
{
    // WebView fills entire editor
    webView->setBounds(getLocalBounds());
}

std::optional<juce::WebBrowserComponent::Resource>
DrumRouletteAudioProcessorEditor::getResource(const juce::String& url)
{
    auto makeVector = [](const char* data, int size) {
        return std::vector<std::byte>(
            reinterpret_cast<const std::byte*>(data),
            reinterpret_cast<const std::byte*>(data) + size
        );
    };

    // Pattern #8: Explicit URL mapping (NOT loop over BinaryData)
    // Root "/" → index.html
    if (url == "/" || url == "/index.html") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::index_html, BinaryData::index_htmlSize),
            juce::String("text/html")
        };
    }

    // JUCE JavaScript library
    if (url == "/js/juce/index.js") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::index_js, BinaryData::index_jsSize),
            juce::String("text/javascript")
        };
    }

    // Pattern #13: check_native_interop.js (REQUIRED for WebView)
    if (url == "/js/juce/check_native_interop.js") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::check_native_interop_js, BinaryData::check_native_interop_jsSize),
            juce::String("text/javascript")
        };
    }

    // Resource not found
    juce::Logger::writeToLog("DrumRoulette: Resource not found: " + url);
    return std::nullopt;
}
