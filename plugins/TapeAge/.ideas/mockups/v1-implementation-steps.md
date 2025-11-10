# TapeAge v1 UI Implementation Steps

**Mockup Version:** v1
**Generated:** 2025-11-10
**Window Size:** 800x600

This checklist guides you through integrating the v1 UI mockup into TapeAge plugin.

---

## Step 1: Create UI Directory Structure

```bash
mkdir -p plugins/TapeAge/ui/public
mkdir -p plugins/TapeAge/ui/js/juce
```

---

## Step 2: Copy HTML to Plugin

```bash
cp plugins/TapeAge/.ideas/mockups/v1-ui.html plugins/TapeAge/ui/public/index.html
```

**Verify:** `plugins/TapeAge/ui/public/index.html` exists

---

## Step 3: Set Up JUCE WebView Bridge

Create `plugins/TapeAge/ui/js/juce/index.js`:

```javascript
// JUCE WebView integration bridge
// This file bridges the HTML UI with JUCE C++ backend

export function getSliderState(paramId) {
  if (window.__juce__ && window.__juce__.backend) {
    return window.__juce__.backend.getSliderState(paramId);
  }

  console.warn(`JUCE backend not available for parameter: ${paramId}`);
  return null;
}

export function getToggleButtonState(paramId) {
  if (window.__juce__ && window.__juce__.backend) {
    return window.__juce__.backend.getToggleButtonState(paramId);
  }

  console.warn(`JUCE backend not available for parameter: ${paramId}`);
  return null;
}

export function getComboBoxState(paramId) {
  if (window.__juce__ && window.__juce__.backend) {
    return window.__juce__.backend.getComboBoxState(paramId);
  }

  console.warn(`JUCE backend not available for parameter: ${paramId}`);
  return null;
}

// Initialize JUCE backend when available
window.addEventListener('DOMContentLoaded', () => {
  console.log('JUCE WebView bridge initialized');

  if (!window.__juce__) {
    console.warn('JUCE backend not detected - running in standalone mode');
  }
});
```

**Verify:** `plugins/TapeAge/ui/js/juce/index.js` exists

---

## Step 4: Update PluginEditor.h

Replace the existing `TapeAgeAudioProcessorEditor` class with the boilerplate from `v1-editor.h`:

```cpp
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
```

**Verify:** Member declaration order is correct (Relays → WebView → Attachments)

---

## Step 5: Update PluginEditor.cpp

Replace the existing implementation with the boilerplate from `v1-editor.cpp`.

**Key sections to include:**

1. Constructor initialization list (correct order)
2. Resource provider for ui/ directory
3. Relay registration with WebView
4. Parameter attachments
5. Editor size: `setSize(800, 600)`
6. Navigate to `ui://index.html`

**Verify:** All parameters (drive, age, mix) are attached correctly

---

## Step 6: Update CMakeLists.txt

Add the configurations from `v1-cmake.txt`:

1. Enable WebView: `NEEDS_WEB_BROWSER TRUE`
2. Generate binary data for ui/ directory
3. Link `TapeAge_BinaryData` target
4. Platform-specific WebView configuration
5. Copy UI files to build directory (development)

**Verify:** CMakeLists.txt compiles without errors

---

## Step 7: Build Plugin

```bash
cd plugins/TapeAge
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

**Expected output:**
- No compilation errors
- Binary data generated for UI files
- Plugin binary created successfully

**Troubleshooting:**
- If WebView2 errors on Windows: Ensure WebView2 SDK is installed
- If WebKit errors on macOS: Verify Xcode installation
- If missing JUCE modules: Check `juce_gui_extra` is included

---

## Step 8: Test in Standalone

```bash
/show-standalone TapeAge
```

**Expected behavior:**
- Plugin window opens at 800x600
- Creamy beige background visible
- VU meter animating at top
- "TAPE AGE" title in center
- 3 brass knobs (DRIVE, AGE, MIX) at bottom
- Knobs respond to mouse drag (vertical)
- Parameter values update in real-time

**Verify:**
- UI loads without errors
- Knobs control parameters bidirectionally
- VU meter animates smoothly
- No JavaScript console errors

---

## Step 9: Test in DAW

Load TapeAge in your DAW and verify:

1. UI renders correctly
2. Knobs control audio processing
3. Automation writes parameter changes
4. UI updates when automation is played back
5. Window size is correct (800x600)

---

## Step 10: Final Verification

**Checklist:**
- [ ] UI matches mockup design
- [ ] All parameters (drive, age, mix) functional
- [ ] VU meter animates based on audio output
- [ ] Knobs have smooth interaction
- [ ] No memory leaks (check with profiler)
- [ ] Works in Standalone and DAW
- [ ] Plugin state saves/restores correctly

---

## Troubleshooting Common Issues

### UI doesn't load
- Check resource provider in PluginEditor.cpp
- Verify ui/ files are embedded in binary data
- Check WebView backend is available on platform

### Parameters don't respond
- Verify member declaration order (Relays → WebView → Attachments)
- Check parameter IDs match between C++ and JavaScript
- Ensure attachments are created with correct parameters

### Build errors
- Check JUCE version supports WebView
- Verify platform-specific WebView libraries are installed
- Ensure `juce_gui_extra` module is included

### VU meter not animating
- Check audio output is being routed to meter
- Verify canvas rendering code in HTML
- Test with audio signal to confirm DSP is running

---

## Next Steps After Implementation

Once UI is working:

1. **Proceed to DSP implementation** (Stage 4)
2. **Hook up VU meter to actual audio output levels**
3. **Test with various audio sources**
4. **Optimize rendering performance if needed**

---

## Files Generated in This Mockup

1. `v1-ui.yaml` - Design specification
2. `v1-ui.html` - Production HTML (with JUCE integration)
3. `v1-ui-test.html` - Browser test version (mock JUCE)
4. `v1-editor.h` - C++ header boilerplate
5. `v1-editor.cpp` - C++ implementation boilerplate
6. `v1-cmake.txt` - Build configuration snippets
7. `v1-implementation-steps.md` - This file

All files located in: `plugins/TapeAge/.ideas/mockups/`
