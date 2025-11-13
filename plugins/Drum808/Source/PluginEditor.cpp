#include "PluginEditor.h"
#include "BinaryData.h"

Drum808AudioProcessorEditor::Drum808AudioProcessorEditor(Drum808AudioProcessor& p)
    : AudioProcessorEditor(&p), processorRef(p)
{
    // Create WebView with resource provider (Pattern 11 - initialize in constructor body)
    webView = std::make_unique<juce::WebBrowserComponent>(
        juce::WebBrowserComponent::Options{}
            .withNativeIntegrationEnabled()
            .withResourceProvider([this](const juce::String& url) {
                return getResource(url);
            })
    );

    addAndMakeVisible(*webView);

    // Load UI
    webView->goToURL(juce::WebBrowserComponent::getResourceProviderRoot());

    // Set window size (from mockup)
    setSize(1000, 550);
}

Drum808AudioProcessorEditor::~Drum808AudioProcessorEditor()
{
}

void Drum808AudioProcessorEditor::paint(juce::Graphics& g)
{
    // WebView handles all painting
    juce::ignoreUnused(g);
}

void Drum808AudioProcessorEditor::resized()
{
    // WebView fills entire editor
    webView->setBounds(getLocalBounds());
}

std::optional<juce::WebBrowserComponent::Resource>
Drum808AudioProcessorEditor::getResource(const juce::String& url)
{
    auto makeVector = [](const char* data, int size) {
        return std::vector<std::byte>(
            reinterpret_cast<const std::byte*>(data),
            reinterpret_cast<const std::byte*>(data) + size
        );
    };

    // CRITICAL: Explicit URL mapping (Pattern 8 - NOT generic loop)
    if (url == "/" || url == "/index.html") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::index_html, BinaryData::index_htmlSize),
            juce::String("text/html")
        };
    }

    if (url == "/js/juce/index.js") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::index_js, BinaryData::index_jsSize),
            juce::String("text/javascript")
        };
    }

    if (url == "/js/juce/check_native_interop.js") {
        return juce::WebBrowserComponent::Resource {
            makeVector(BinaryData::check_native_interop_js,
                      BinaryData::check_native_interop_jsSize),
            juce::String("text/javascript")
        };
    }

    // Resource not found
    juce::Logger::writeToLog("Resource not found: " + url);
    return std::nullopt;
}
