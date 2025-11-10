---
name: ui-mockup
description: Generate production-ready WebView UI mockups (7 files per version)
allowed-tools:
  - Read
  - Write
preconditions:
  - None (can work standalone or with creative brief)
---

# ui-mockup Skill

**Purpose:** Generate production-ready WebView UIs. The HTML generated IS the plugin UI, not a throwaway prototype.

## Phase 1: Load Context

Check for existing documentation to understand the plugin's purpose and requirements:

```bash
test -f "plugins/$PLUGIN_NAME/.ideas/creative-brief.md"
find "plugins/$PLUGIN_NAME/.ideas/improvements/" -name "*.md"
test -d "plugins/$PLUGIN_NAME/Source/"  # For redesigns
```

**What to extract:**

- **Plugin type**: Compressor, EQ, reverb, synth, utility, etc.
- **Parameters**: Names, types (float/bool/choice), ranges, defaults
- **UI vision**: Layout preferences, visual style, user workflow
- **Colors**: Brand colors, dark/light theme preferences
- **Special elements**: Visualizers, waveforms, custom graphics

**Example extraction from creative-brief.md:**

```markdown
# Vintage Compressor
- Warm, analog-style dynamics processor
- 5 parameters: threshold, ratio, attack, release, makeup gain
- UI vision: "Think LA-2A meets modern UI"
- Colors: Warm bronze (#d4a574), deep black (#1a1a1a)
- Special: VU meter with smooth ballistics
```

Extract these details to guide the mockup design.

## Phase 1.5: Free-Form UI Vision

Before asking specific questions, let the user describe their vision freely:

```
What should the UI look like?

Describe your vision - layout, colors, style, special elements. I'll ask follow-ups for anything missing.
```

**Why this phase exists:**

Users often have a clear vision but struggle with structured questions. Free-form capture lets them express ideas naturally. Listen for:

- Layout preferences: "controls on the left, visualizer on the right"
- Visual references: "like FabFilter Pro-C", "vintage analog gear"
- Mood/feel: "minimal and clean", "skeuomorphic wood panels"
- Special requests: "animated VU meter", "resizable window"

**Example user responses:**

> "I want a dark theme with cyan accents. Big rotary knobs for the main controls, arranged in a horizontal row. Maybe a frequency analyzer in the background?"

> "Something minimal - just sliders and numbers. White background, no graphics."

> "Inspired by vintage API gear - lots of black and silver, chunky buttons, red LED clip indicator."

Capture these verbatim notes before moving to targeted questions.

## Phase 2: Targeted Design Questions

Ask **only** about gaps not covered in Phase 1.5. One question at a time, wait for answers.

### Window Size

**If not mentioned, ask:**

```
What window dimensions? (e.g., 600x400, 800x600)
```

**Common sizes:**

- **Small utility**: 400x300 (simple processors, one or two controls)
- **Standard effect**: 600x400 (typical compressor/EQ)
- **Large effect**: 800x600 (complex multi-band, visual feedback)
- **Synth**: 1000x700+ (oscillators, envelopes, modulation matrix)

**Default if user unsure:** 600x400 (safe for most effects)

### Layout Organization

**If not described, ask:**

```
How should controls be organized? (grid, vertical sections, custom)
```

**Common layouts:**

- **Grid**: Equal-sized controls in rows/columns (clean, organized)
- **Vertical sections**: Logical groupings (input → processing → output)
- **Horizontal sections**: Signal flow left-to-right (compressor stages)
- **Custom**: Unique arrangements (circular modulation matrix)

**Example clarification:**

> User: "Not sure, what works best for a compressor?"
> You: "Compressors often use horizontal flow: input controls (threshold/ratio) on left, timing (attack/release) in center, output (makeup gain) on right. Want that?"

### Control Style

**If not specified, ask:**

```
What control style? (rotary knobs, linear sliders, buttons)
```

**Control types:**

- **Rotary knobs**: Classic feel, save space, good for precise values
- **Linear sliders**: Fast adjustments, good for sweeps
- **Buttons**: On/off, mode switching
- **Combo boxes**: Multiple options (filter types, ratios)

**Match to plugin type:**

- Compressors/EQs → Rotary knobs (analog feel)
- Gates/expanders → Linear sliders (threshold visualization)
- Utilities → Buttons/combos (functional, not expressive)

### Color Scheme

**If not provided, ask:**

```
Color scheme? (dark, light, custom colors)
```

**Presets:**

- **Dark** (default): `background: #2b2b2b`, `primary: #4a9eff`, `text: #ffffff`
- **Light**: `background: #f5f5f5`, `primary: #007aff`, `text: #333333`
- **Custom**: Ask for specific hex codes

**Brand consideration:**

If this is part of a plugin suite, ask: "Should this match other plugins you've built?"

### Special Elements

**If mentioned but vague, clarify:**

```
You mentioned [VU meter / analyzer / waveform]. What should it display exactly?
```

**Common special elements:**

- **VU meter**: Input/output level, gain reduction
- **Frequency analyzer**: Real-time FFT display
- **Waveform display**: Input signal visualization
- **Envelope follower**: ADSR visual feedback
- **Modulation indicators**: LFO/envelope routing

**Implementation note:** Some special elements may need C++ rendering (OpenGL). For Phase 1, design them in HTML/CSS with the understanding they may need Stage 5 (GUI) implementation.

## Phase 3: Generate Hierarchical YAML

Create `plugins/[Name]/.ideas/mockups/v[N]-ui.yaml`:

**Purpose:** Machine-readable design spec that guides HTML generation and C++ implementation.

**Structure:**

```yaml
# v1 UI Design Specification
# Generated: [timestamp]
# Plugin: [PluginName]

window:
  width: 600
  height: 400
  resizable: false  # true if user requested

colors:
  background: "#2b2b2b"
  primary: "#4a9eff"
  secondary: "#666666"
  text: "#ffffff"
  accent: "#ff6b6b"  # For warnings/clip indicators

typography:
  header: "Inter, system-ui, sans-serif"
  body: "Inter, system-ui, sans-serif"
  monospace: "'Roboto Mono', monospace"  # For numeric displays

sections:
  header:
    height: 60
    components:
      - type: title
        text: "[Plugin Name]"
        style: "font-size: 24px; font-weight: 700"

      - type: bypass_button
        id: bypass
        position: "top-right"

  main_controls:
    layout: grid
    columns: 3
    gap: 20
    components:
      - type: rotary_slider
        id: threshold
        label: "Threshold"
        range: [-60.0, 0.0]
        default: -20.0
        units: "dB"
        valueDisplay: true

      - type: rotary_slider
        id: ratio
        label: "Ratio"
        range: [1.0, 20.0]
        default: 4.0
        skew: 0.5  # Logarithmic scaling
        units: ":1"

      - type: rotary_slider
        id: gain
        label: "Makeup Gain"
        range: [0.0, 24.0]
        default: 0.0
        units: "dB"

  visualizer:
    type: gain_reduction_meter
    height: 100
    colors:
      safe: "#4caf50"
      warning: "#ff9800"
      danger: "#f44336"
```

**Key YAML features:**

- **Hierarchical structure**: Sections → Components (matches visual layout)
- **Type annotations**: Each component has a `type` field (generates correct HTML)
- **Parameter linkage**: `id` field matches DSP parameter IDs
- **Layout hints**: Grid columns, gaps, positioning
- **Styling metadata**: Colors, fonts, sizes

**Validation:**

After generating, verify:

- All parameter IDs are unique
- Range values make sense (min < default < max)
- Colors are valid hex codes
- Layout math works (columns × component width + gaps ≤ window width)

## Phase 4: Generate Production HTML

Create `plugins/[Name]/.ideas/mockups/v[N]-ui.html`:

**Purpose:** This IS the plugin UI. JUCE's WebBrowserComponent loads this file.

**Full example (simplified for documentation):**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[PluginName]</title>
  <style>
    /* Native plugin feel */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      user-select: none;  /* Disable text selection */
      -webkit-user-select: none;
      cursor: default;  /* Not pointer - this isn't a web page */
    }

    body {
      font-family: 'Inter', system-ui, sans-serif;
      background: #2b2b2b;
      color: #ffffff;
      width: 600px;
      height: 400px;
      overflow: hidden;  /* No scrollbars */
    }

    /* Header section */
    .header {
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 20px;
      border-bottom: 1px solid #444;
    }

    .title {
      font-size: 24px;
      font-weight: 700;
      letter-spacing: -0.5px;
    }

    /* Rotary slider (custom element) */
    .rotary-slider {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
    }

    .rotary-knob {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #3a3a3a, #2a2a2a);
      border: 2px solid #4a9eff;
      position: relative;
      cursor: ns-resize;  /* Vertical drag */
    }

    .rotary-indicator {
      position: absolute;
      top: 10px;
      left: 50%;
      width: 3px;
      height: 30px;
      background: #4a9eff;
      transform-origin: 50% 30px;
      transform: translateX(-50%) rotate(0deg);
      transition: transform 0.05s ease-out;  /* Smooth but responsive */
    }

    .rotary-label {
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #999;
    }

    .rotary-value {
      font-family: 'Roboto Mono', monospace;
      font-size: 14px;
      color: #4a9eff;
    }
  </style>
</head>
<body>
  <div class="header">
    <div class="title">[PluginName]</div>
    <button id="bypass" class="bypass-button">Bypass</button>
  </div>

  <div class="main-controls">
    <div class="rotary-slider" id="threshold-container">
      <div class="rotary-label">Threshold</div>
      <div class="rotary-knob">
        <div class="rotary-indicator"></div>
      </div>
      <div class="rotary-value">-20.0 dB</div>
    </div>

    <!-- More controls... -->
  </div>

  <script type="module">
    // JUCE integration
    import { getSliderState, getButtonState } from "./js/juce/index.js";

    // Threshold parameter binding
    const thresholdState = getSliderState("threshold");
    const thresholdKnob = document.querySelector("#threshold-container .rotary-knob");
    const thresholdIndicator = document.querySelector("#threshold-container .rotary-indicator");
    const thresholdValue = document.querySelector("#threshold-container .rotary-value");

    // Drag interaction
    let isDragging = false;
    let startY = 0;
    let startValue = 0;

    thresholdKnob.addEventListener("mousedown", (e) => {
      isDragging = true;
      startY = e.clientY;
      startValue = thresholdState.getNormalisedValue();
      e.preventDefault();
    });

    window.addEventListener("mousemove", (e) => {
      if (!isDragging) return;

      const deltaY = startY - e.clientY;  // Inverted: drag up = increase
      const sensitivity = 0.005;  // Pixels to value ratio
      const newValue = Math.max(0, Math.min(1, startValue + deltaY * sensitivity));

      thresholdState.setNormalisedValue(newValue);
    });

    window.addEventListener("mouseup", () => {
      isDragging = false;
    });

    // Parameter → UI updates
    thresholdState.valueChangedEvent.addListener((normalisedValue) => {
      // Update visual rotation (240° range, -120° to +120°)
      const angle = (normalisedValue * 240) - 120;
      thresholdIndicator.style.transform = `translateX(-50%) rotate(${angle}deg)`;

      // Update numeric display
      const dbValue = -60 + (normalisedValue * 60);  // Range: -60 to 0
      thresholdValue.textContent = `${dbValue.toFixed(1)} dB`;
    });

    // Disable context menu (right-click)
    document.addEventListener("contextmenu", (e) => e.preventDefault());
  </script>
</body>
</html>
```

**Critical production details:**

1. **Exact dimensions**: Body width/height match YAML `window` values
2. **No web behaviors**: Disable text selection, scrollbars, context menu, pointer cursor
3. **JUCE bindings**: Use `getSliderState(id)` from JUCE's injected API
4. **Smooth interactions**: Fast transitions (<100ms), responsive drag
5. **Bidirectional sync**: Parameter changes update UI, UI changes update parameters

## Phase 5: Generate Browser Test HTML

Create `plugins/[Name]/.ideas/mockups/v[N]-ui-test.html`:

**Purpose:** Test the UI in a browser (Chrome/Firefox) without building the plugin. Rapid iteration.

**Differences from production HTML:**

```html
<!-- Same <head> and <style> as production -->

<body>
  <!-- Same UI elements -->

  <script type="module">
    // MOCK JUCE integration (console logs instead of C++ calls)
    const mockSliderState = (id) => ({
      getNormalisedValue: () => 0.5,
      setNormalisedValue: (value) => {
        console.log(`[MOCK] ${id}.setNormalisedValue(${value.toFixed(3)})`);
      },
      valueChangedEvent: {
        addListener: (callback) => {
          console.log(`[MOCK] ${id}.valueChangedEvent.addListener()`);
          // Simulate initial callback
          setTimeout(() => callback(0.5), 100);
        }
      }
    });

    const getSliderState = mockSliderState;
    const getButtonState = (id) => ({ /* similar mock */ });

    // Rest of the code is IDENTICAL to production version
    const thresholdState = getSliderState("threshold");
    // ... (same interaction code)
  </script>
</body>
```

**Testing workflow:**

1. Open `v[N]-ui-test.html` in browser
2. Interact with controls
3. Check browser console for parameter changes
4. Tweak CSS/layout
5. Refresh page to see changes
6. Repeat until satisfied
7. Copy changes to production HTML (`v[N]-ui.html`)

**No build required.** Iterate in seconds instead of minutes.

## Phase 6: Generate C++ Boilerplate

### Part A: Create `v[N]-editor.h`

**CRITICAL: Member declaration order matters.** Wrong order = crash on plugin load.

**Correct order:**

```cpp
private:
    // 1. RELAYS FIRST (no dependencies)
    juce::WebSliderRelay thresholdRelay;
    juce::WebSliderRelay ratioRelay;
    juce::WebSliderRelay gainRelay;
    juce::WebToggleButtonRelay bypassRelay;

    // 2. WEBVIEW SECOND (depends on relays existing)
    juce::WebBrowserComponent webView;

    // 3. ATTACHMENTS LAST (depend on both relays and webView)
    juce::WebSliderParameterAttachment thresholdAttachment;
    juce::WebSliderParameterAttachment ratioAttachment;
    juce::WebSliderParameterAttachment gainAttachment;
    juce::WebToggleButtonParameterAttachment bypassAttachment;

    // 4. APVTS REFERENCE (always last)
    juce::AudioProcessorValueTreeState& apvts;
```

**Why this order:**

- **Relays** register themselves globally on construction
- **WebView** initialization calls JavaScript that looks up relays by ID
- **Attachments** connect relays to APVTS parameters (need both to exist)
- **Wrong order** → Relay lookup fails → nullptr dereference → crash

**Example crash from wrong order:**

```
Wrong order:
    juce::WebBrowserComponent webView;  // Initializes JS
    juce::WebSliderRelay thresholdRelay;  // Relay created AFTER lookup

Crash:
    JavaScript: getSliderState("threshold")
    → Relay lookup fails (not registered yet)
    → Returns null
    → User drags slider
    → nullptr.setNormalisedValue()
    → CRASH
```

**Full editor.h template:**

```cpp
#pragma once
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_gui_extra/juce_gui_extra.h>

class [PluginName]Editor : public juce::AudioProcessorEditor
{
public:
    [PluginName]Editor([PluginName]Processor& p, juce::AudioProcessorValueTreeState& apvts);
    ~[PluginName]Editor() override;

    void paint(juce::Graphics&) override;
    void resized() override;

private:
    [PluginName]Processor& audioProcessor;

    // CRITICAL ORDER (see Phase 6 documentation)
    juce::WebSliderRelay thresholdRelay;
    juce::WebSliderRelay ratioRelay;
    juce::WebSliderRelay gainRelay;
    juce::WebToggleButtonRelay bypassRelay;

    juce::WebBrowserComponent webView;

    juce::WebSliderParameterAttachment thresholdAttachment;
    juce::WebSliderParameterAttachment ratioAttachment;
    juce::WebSliderParameterAttachment gainAttachment;
    juce::WebToggleButtonParameterAttachment bypassAttachment;

    juce::AudioProcessorValueTreeState& apvts;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR([PluginName]Editor)
};
```

### Part B: Create `v[N]-editor.cpp`

```cpp
#include "PluginEditor.h"
#include "PluginProcessor.h"

// Resource provider for ui/ directory
class UIResourceProvider : public juce::WebBrowserComponent::Resource
{
public:
    juce::String getResourceAsString(const juce::String& path) override
    {
        // JUCE's BinaryData namespace (generated from CMake)
        if (path == "/" || path == "/index.html")
            return juce::String::createStringFromData(BinaryData::index_html,
                                                       BinaryData::index_htmlSize);

        // Add more files as needed (CSS, JS modules)
        return {};
    }
};

[PluginName]Editor::[PluginName]Editor([PluginName]Processor& p,
                                        juce::AudioProcessorValueTreeState& apvts)
    : AudioProcessorEditor(&p)
    , audioProcessor(p)
    , thresholdRelay("threshold")
    , ratioRelay("ratio")
    , gainRelay("gain")
    , bypassRelay("bypass")
    , thresholdAttachment(apvts, "threshold", thresholdRelay)
    , ratioAttachment(apvts, "ratio", ratioRelay)
    , gainAttachment(apvts, "gain", gainRelay)
    , bypassAttachment(apvts, "bypass", bypassRelay)
    , apvts(apvts)
{
    addAndMakeVisible(webView);

    webView.goToURL(juce::WebBrowserComponent::Resource(new UIResourceProvider()).withResourceProvider());

    setSize(600, 400);  // From YAML window dimensions
    setResizable(false, false);  // From YAML resizable setting
}

[PluginName]Editor::~[PluginName]Editor()
{
}

void [PluginName]Editor::paint(juce::Graphics& g)
{
    g.fillAll(juce::Colours::black);  // Fallback while WebView loads
}

void [PluginName]Editor::resized()
{
    webView.setBounds(getLocalBounds());
}
```

**Key C++ details:**

- **Relay IDs**: Must match HTML JavaScript `getSliderState("threshold")` calls
- **Parameter IDs**: Must match APVTS parameter definitions in PluginProcessor
- **Attachment construction**: Links relay → parameter bidirectionally
- **Resource provider**: Loads HTML from compiled binary data

## Phase 7: Generate Build Configuration

Create `plugins/[Name]/.ideas/mockups/v[N]-cmake.txt`:

**Purpose:** CMake snippets to add to `plugins/[Name]/CMakeLists.txt`.

**Required changes:**

```cmake
# 1. Enable WebView support
juce_add_plugin([PluginName]
    # ... existing options ...
    NEEDS_WEB_BROWSER TRUE  # Enable juce_gui_extra WebView
)

# 2. Generate binary data from ui/ directory
juce_add_binary_data([PluginName]Data
    SOURCES
        ui/public/index.html
        # Add more files if needed:
        # ui/public/styles.css
        # ui/public/script.js
)

# 3. Link binary data to plugin target
target_link_libraries([PluginName]
    PRIVATE
        [PluginName]Data
        juce::juce_gui_extra  # WebBrowserComponent
        # ... existing links ...
)

# 4. Platform-specific WebView setup
if(APPLE)
    target_compile_definitions([PluginName] PRIVATE
        JUCE_WEB_BROWSER=1
        JUCE_USE_CURL=0  # Use native macOS networking
    )
elseif(WIN32)
    target_compile_definitions([PluginName] PRIVATE
        JUCE_WEB_BROWSER=1
        JUCE_USE_CURL=1  # Use curl for Windows WebView2
    )
endif()
```

**Explanation:**

- **NEEDS_WEB_BROWSER TRUE**: Includes necessary JUCE modules
- **juce_add_binary_data**: Compiles HTML into C++ `BinaryData` namespace
- **juce_gui_extra**: Provides `WebBrowserComponent` class
- **Platform defines**: macOS uses WebKit, Windows uses WebView2

## Phase 8: Generate Implementation Checklist

Create `plugins/[Name]/.ideas/mockups/v[N]-implementation-steps.md`:

**Purpose:** Step-by-step guide for applying the mockup to the actual plugin.

```markdown
# Implementation Steps for v[N] Mockup

**Generated:** [timestamp]
**Plugin:** [PluginName]

## Prerequisites

- [ ] Plugin foundation exists (PluginProcessor, parameters defined)
- [ ] CMake build configured

## Step 1: Copy HTML to Plugin

```bash
mkdir -p plugins/[Name]/ui/public
cp .ideas/mockups/v[N]-ui.html plugins/[Name]/ui/public/index.html
```

## Step 2: Update PluginEditor.h

Replace the entire private section with:

```cpp
[Paste v[N]-editor.h boilerplate from Phase 6]
```

**CRITICAL:** Maintain the exact member declaration order (Relays → WebView → Attachments).

## Step 3: Update PluginEditor.cpp

Replace constructor and methods with:

```cpp
[Paste v[N]-editor.cpp boilerplate from Phase 6]
```

**Update these values to match your plugin:**

- Window dimensions: `setSize(600, 400)` (from YAML)
- Relay IDs: Must match HTML `getSliderState()` calls
- Parameter IDs: Must match APVTS definitions

## Step 4: Update CMakeLists.txt

Add the following sections:

```cmake
[Paste v[N]-cmake.txt snippets from Phase 7]
```

**Check:**

- [ ] `NEEDS_WEB_BROWSER TRUE` added to `juce_add_plugin()`
- [ ] Binary data target created
- [ ] Binary data linked to plugin target
- [ ] Platform definitions added

## Step 5: Build and Test

```bash
cd build
cmake ..
cmake --build . --config Release
```

**If build fails:**

- Check member declaration order in PluginEditor.h
- Verify all relay IDs match between C++ and HTML
- Ensure ui/public/index.html exists

## Step 6: Test in Standalone

```bash
/show-standalone [PluginName]
```

**Test checklist:**

- [ ] UI loads without white screen
- [ ] All controls visible and styled correctly
- [ ] Parameters respond to UI interactions
- [ ] UI updates when parameters change (automation, preset load)
- [ ] No console errors

## Step 7: Test in DAW

Load plugin in your DAW and verify:

- [ ] UI renders correctly in plugin window
- [ ] Automation works (draw automation, verify UI follows)
- [ ] Preset recall works (save preset, change params, load preset)
- [ ] No crashes or freezes

## Troubleshooting

**White screen:** Resource provider not loading HTML correctly. Check BinaryData includes.

**Controls don't respond:** Relay IDs mismatch between C++ and JavaScript.

**Crash on load:** Member declaration order wrong. Relays must come before WebView.

**UI updates slowly:** Remove transition CSS for real-time parameters.
```

## Generate parameter-spec.md

After mockup finalized (user chooses "Finalize and proceed to implementation" from decision menu), extract all parameters from the YAML and create the canonical parameter spec:

**Create `plugins/[Name]/.ideas/parameter-spec.md`:**

```markdown
# [PluginName] - Parameter Specification

**Generated:** [timestamp]
**From:** v[N]-ui.yaml

**CRITICAL CONTRACT:** This file is immutable during implementation (Stages 2-5).

All stages reference this spec. Any changes require creating a new improvement document.

## Parameters

| ID        | Type   | Range         | Default | Skew | UI Control   | Units | DSP Usage           |
| --------- | ------ | ------------- | ------- | ---- | ------------ | ----- | ------------------- |
| threshold | Float  | [-60.0, 0.0]  | -20.0   | 1.0  | Rotary knob  | dB    | Compressor detector |
| ratio     | Float  | [1.0, 20.0]   | 4.0     | 0.5  | Rotary knob  | :1    | Gain reduction      |
| attack    | Float  | [0.1, 100.0]  | 10.0    | 0.3  | Rotary knob  | ms    | Envelope follower   |
| release   | Float  | [10.0, 1000.0]| 100.0   | 0.3  | Rotary knob  | ms    | Envelope follower   |
| gain      | Float  | [0.0, 24.0]   | 0.0     | 1.0  | Rotary knob  | dB    | Output makeup gain  |
| bypass    | Bool   | [0, 1]        | 0       | -    | Toggle       | -     | Bypass processing   |

## Parameter Details

### threshold

**Purpose:** Level above which compression begins.

**DSP Implementation:** Compared against input RMS/peak to trigger gain reduction.

**UI Behavior:** Drag vertically. Display updates in real-time with 0.1 dB precision.

### ratio

**Purpose:** Amount of compression applied above threshold.

**DSP Implementation:** `gainReduction = (inputLevel - threshold) * (1 - 1/ratio)`

**UI Behavior:** Logarithmic scaling (skew 0.5) for better control at lower ratios.

**Special values:**

- 1:1 = No compression
- 4:1 = Standard compression
- 10:1 = Heavy compression
- 20:1 = Limiting

[Continue for all parameters...]

## Contract Rules

1. **Stage 2 (Foundation):** Create APVTS with these exact IDs, ranges, defaults
2. **Stage 3 (Shell):** Expose these parameters to DAW hosts
3. **Stage 4 (DSP):** Implement audio processing using these parameters
4. **Stage 5 (GUI):** Bind UI controls to these parameter IDs
6. **No changes during implementation:** Any modifications require `/improve` workflow

## Verification Checklist

Before Stage 2 (Foundation) can proceed:

- [ ] All parameters have unique IDs
- [ ] All ranges are valid (min < default < max)
- [ ] All skew values are > 0 (1.0 = linear)
- [ ] All UI controls are specified
- [ ] All DSP usages are described
- [ ] Contract rule understood and accepted
```

**Mark as contract in `.continue-here.md`:**

```markdown
**Contracts:**

- ✅ creative-brief.md (locked)
- ✅ parameter-spec.md (locked) ← Generated from v[N]-ui.yaml
- ⏳ architecture.md (Stage 1 Planning)
- ⏳ plan.md (Stage 1 Planning)
```

## Versioning

**First mockup:** v1

**Redesign:** v2

- Read v1 files as baseline
- Ask: "What do you want to change from v1?"
- Generate new set of 7 files (v2-ui.yaml, v2-ui.html, etc.)
- Preserve v1 files (idea lineage)

**Example redesign flow:**

```
User: "Redesign the UI for [PluginName]"
You: "Loading v1 mockup... Found 3 rotary knobs in horizontal layout. What should change?"
User: "Make the knobs bigger and add a VU meter"
You: [Generate v2 with larger knobs + VU meter, preserve v1]
```

**Further iterations:** v3, v4, etc. All versions preserved in `.ideas/mockups/`.

## Decision Menu After Creation

**After generating all 7 files:**

```
✓ Mockup v[N] created (7 files)

Files generated:
- v[N]-ui.yaml (design specification)
- v[N]-ui.html (production WebView)
- v[N]-ui-test.html (browser testing)
- v[N]-editor.h (C++ header)
- v[N]-editor.cpp (C++ implementation)
- v[N]-cmake.txt (build configuration)
- v[N]-implementation-steps.md (integration guide)

What's next?
1. Finalize and proceed to implementation (recommended)
2. Iterate on this design (create v[N+1])
3. Test in browser first (open v[N]-ui-test.html)
4. Save as template (future: UI template library)
5. Other

Choose (1-5): _
```

**Handle responses:**

### Option 1: Finalize and proceed to implementation

- Generate `parameter-spec.md` (the CRITICAL CONTRACT)
- Update `.continue-here.md`:

```markdown
**Status:** Ready for Stage 5 (GUI)

**Last step:** UI mockup v[N] finalized

**Contracts:**

- ✅ creative-brief.md (locked)
- ✅ parameter-spec.md (locked) ← Just generated
- ✅ architecture.md (locked) [if Stage 1 complete]
- ✅ plan.md (locked) [if Stage 1 complete]

**Next:** Apply v[N] mockup to PluginEditor (see v[N]-implementation-steps.md)

**Resume command:** /continue [PluginName]
```

- Confirm to user:

```
✓ parameter-spec.md generated (CRITICAL CONTRACT)
✓ Ready for Stage 5 (GUI) implementation

When ready, use: /continue [PluginName]
```

### Option 2: Iterate on this design

Ask:

```
What would you like to change about v[N]?

(Layout, colors, control types, sizes, add/remove elements, etc.)
```

Wait for response, then create v[N+1] with requested changes.

### Option 3: Test in browser first

```
Opening v[N]-ui-test.html in browser...

Test checklist:
- Verify all controls visible and styled correctly
- Test interactions (drag sliders, click buttons)
- Check console for parameter change logs
- Try different window sizes (if resizable)

When satisfied, choose option 1 to finalize.
```

Open file in default browser, then re-show decision menu.

### Option 4: Save as template

```
[Future feature - Phase 4]

This will save v[N] as a reusable template for future plugins.
Template features:
- Parameterized (plugin name, colors, control count)
- Instant mockup generation
- Consistent branding across plugin suite

For now, v[N] files are available in .ideas/mockups/ for manual reuse.
```

### Option 5: Other

Ask:

```
What would you like to do?
```

## Integration Points

**Invoked by:**

- `/dream` command → "Create UI mockup" option (after creative brief)
- `plugin-ideation` skill → Automatically after creative brief if user wants UI-first approach
- Natural language: "Design UI for [plugin]", "Mockup the interface", "Create WebView UI"
- `plugin-workflow` skill → Stage 5 (GUI) if no mockup exists yet

**Creates:**

- 7 files per version in `plugins/[Name]/.ideas/mockups/`
- `parameter-spec.md` (CRITICAL CONTRACT) after finalization

**Updates:**

- `.continue-here.md` (marks UI mockup complete, updates contracts status)

**Blocks:**

- Stage 5 (GUI) implementation until mockup finalized and parameter-spec.md generated

## Success Criteria

Mockup is successful when:

- ✅ All 7 files generated per version (YAML, HTML, test HTML, .h, .cpp, CMake, steps)
- ✅ HTML works in browser (test version shows UI, console logs interactions)
- ✅ HTML has correct JUCE integration (production version uses JUCE API)
- ✅ C++ boilerplate has correct member order (Relays → WebView → Attachments)
- ✅ CMake configuration includes all required changes
- ✅ Implementation steps guide is complete and accurate
- ✅ User chooses "Finalize and proceed" (not stuck iterating)
- ✅ `parameter-spec.md` generated (the CRITICAL CONTRACT)
- ✅ Ready for Stage 5 (GUI) implementation

## Common Issues and Solutions

**Issue:** User keeps iterating, never finalizes

**Solution:** After 3+ iterations, suggest:

```
You've created v1, v2, v3. Diminishing returns on mockups without real testing.

Recommendation: Finalize v3, implement in plugin, test with audio, then improve if needed.

Mockups don't reveal everything - some issues only surface with real DSP feedback.
```

**Issue:** User wants parameter changes during Stage 5 implementation

**Solution:** Explain contract system:

```
parameter-spec.md is immutable during implementation (Stages 2-5).

This prevents drift between GUI, DSP, and plugin specs.

To add/change parameters:
1. Complete current implementation
2. Use /improve [PluginName]
3. Create improvement document
4. Implement changes with updated contracts
```

**Issue:** C++ member order wrong, plugin crashes

**Solution:** Check PluginEditor.h:

```
Wrong order (CRASH):
    juce::WebBrowserComponent webView;  // ❌ WebView first
    juce::WebSliderRelay gainRelay;     // ❌ Relay after

Correct order (WORKS):
    juce::WebSliderRelay gainRelay;     // ✅ Relay first
    juce::WebBrowserComponent webView;  // ✅ WebView after
```

**Issue:** White screen in plugin UI

**Solution:** Check these in order:

1. BinaryData includes ui/public/index.html
2. Resource provider returns correct HTML
3. No JavaScript errors (check browser console with dev tools)
4. WebView enabled in CMake (`NEEDS_WEB_BROWSER TRUE`)
