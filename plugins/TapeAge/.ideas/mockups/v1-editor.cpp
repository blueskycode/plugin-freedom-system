// TapeAge PluginEditor.cpp - C++ Implementation Boilerplate
// Generated from v1-ui.html mockup

#include "PluginEditor.h"
#include "PluginProcessor.h"

TapeAgeAudioProcessorEditor::TapeAgeAudioProcessorEditor(TapeAgeAudioProcessor& p)
    : AudioProcessorEditor(&p),
      audioProcessor(p),
      driveRelay("drive"),
      ageRelay("age"),
      mixRelay("mix"),
      webView(juce::WebBrowserComponent::Options{}
                  .withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
                  .withResourceProvider(
                      [](const juce::String& url)
                      {
                          // Serve files from ui/ directory embedded in binary
                          auto path = url.fromFirstOccurrenceOf("ui/", false, false);

                          if (path.isEmpty() || path == "/")
                              path = "index.html";

                          int dataSize = 0;
                          auto* data = BinaryData::getNamedResource(
                              path.replaceCharacter('/', '_')
                                  .replaceCharacter('.', '_')
                                  .toRawUTF8(),
                              dataSize);

                          if (data != nullptr && dataSize > 0)
                          {
                              juce::MemoryBlock block(data, static_cast<size_t>(dataSize));

                              // Determine MIME type
                              auto mimeType = [&path]() -> juce::String
                              {
                                  if (path.endsWithIgnoreCase(".html")) return "text/html";
                                  if (path.endsWithIgnoreCase(".js"))   return "application/javascript";
                                  if (path.endsWithIgnoreCase(".css"))  return "text/css";
                                  if (path.endsWithIgnoreCase(".json")) return "application/json";
                                  if (path.endsWithIgnoreCase(".svg"))  return "image/svg+xml";
                                  if (path.endsWithIgnoreCase(".png"))  return "image/png";
                                  if (path.endsWithIgnoreCase(".jpg"))  return "image/jpeg";
                                  return "application/octet-stream";
                              }();

                              return juce::WebBrowserComponent::Resource{std::move(block), mimeType};
                          }

                          return juce::WebBrowserComponent::Resource{
                              juce::MemoryBlock{}, "text/plain", 404};
                      },
                      juce::URL{"ui://"})
                  .withUserScript(R"(
                      // Inject JUCE integration bridge
                      window.__juce__ = window.__juce__ || {};
                  )")
                  .withEventListener(
                      [this](const auto& event)
                      {
                          // Handle custom events from WebView if needed
                          DBG("WebView event: " + event.message);
                      }))
{
    // Register relays with WebView
    webView.addWebSliderRelay(&driveRelay);
    webView.addWebSliderRelay(&ageRelay);
    webView.addWebSliderRelay(&mixRelay);

    // Create parameter attachments
    auto& params = audioProcessor.getParameters();

    driveAttachment = std::make_unique<juce::WebSliderParameterAttachment>(
        *dynamic_cast<juce::RangedAudioParameter*>(params.getParameter("drive")),
        driveRelay);

    ageAttachment = std::make_unique<juce::WebSliderParameterAttachment>(
        *dynamic_cast<juce::RangedAudioParameter*>(params.getParameter("age")),
        ageRelay);

    mixAttachment = std::make_unique<juce::WebSliderParameterAttachment>(
        *dynamic_cast<juce::RangedAudioParameter*>(params.getParameter("mix")),
        mixRelay);

    // Add WebView to editor
    addAndMakeVisible(webView);

    // Set editor size (800x600 from mockup)
    setSize(800, 600);

    // Navigate to UI
    webView.goToURL("ui://index.html");
}

TapeAgeAudioProcessorEditor::~TapeAgeAudioProcessorEditor()
{
}

void TapeAgeAudioProcessorEditor::paint(juce::Graphics& g)
{
    // WebView handles all painting
    g.fillAll(juce::Colour(0xfff5f0e8)); // Fallback background color
}

void TapeAgeAudioProcessorEditor::resized()
{
    webView.setBounds(getLocalBounds());
}
