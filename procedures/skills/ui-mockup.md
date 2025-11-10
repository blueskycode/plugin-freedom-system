# ui-mockup

**Purpose:** Generate production-ready WebView UI mockups for JUCE plugins in two phases: design iteration (2 files) then implementation scaffolding (5 additional files). The HTML you generate IS the plugin UI, not a throwaway prototype.

---

## What It Does

Transforms creative vision into a complete, interactive HTML/CSS interface that becomes the actual plugin UI. Works in two phases:
1. **Design Phase:** Generate design files (YAML + test HTML) for rapid iteration
2. **Implementation Phase:** Generate scaffolding (production HTML + C++ boilerplate + build config) after design is finalized

## When To Use

- "Create UI mockup for [plugin]"
- "Design the interface for [plugin]"
- "Show me what [plugin] could look like"
- After completing plugin-ideation (offered as next step)
- Before implementing Stage 5 (GUI)

## Critical Concept

**Traditional workflow (DEPRECATED):**
```
Mockup → Approve → Translate to JUCE components
```

**WebView workflow (CURRENT):**
```
Mockup → Approve → Embed mockup in plugin → DONE
```

No translation. The HTML/CSS mockup IS the production UI.

## How It Works

### Phase 1: Load Context
Reads existing documentation:
- Creative brief (for new plugins)
- Improvement proposals (for enhancements)
- Current implementation (for redesigns)

Extracts: plugin type, parameters, UI vision, color preferences, special elements.

### Phase 1.5: Free-Form UI Vision
Asks: "What should the UI look like?"

Captures your design preferences before asking specific questions.

### Phase 2: Targeted Design Questions
Asks **only** about design gaps not covered in Phase 1.5:
- Window size (if not mentioned)
- Layout organization (if not described)
- Control style (if not specified)
- Color scheme (if not provided)

One question at a time, adaptive to your responses.

### Phase 3: Generate Hierarchical YAML
Creates structured specification:
```yaml
window:
  width: 600
  height: 400

colors:
  background: "#2b2b2b"
  primary: "#4a9eff"

sections:
  main_controls:
    layout: grid
    components:
      - type: rotary_slider
        id: gain
        range: [0.0, 1.0]
```

### Phase 4: Generate Production HTML
Creates self-contained HTML with JUCE integration:
```html
<script type="module">
    import { getSliderState } from './js/juce/index.js';

    const gainState = getSliderState('gain');

    // Bidirectional binding
    slider.addEventListener('input', (e) => {
        gainState.setNormalisedValue(parseFloat(e.target.value));
    });

    gainState.valueChangedEvent.addListener((newValue) => {
        slider.value = newValue;
    });
</script>
```

**IMPORTANT:** Phases 3-4 generate DESIGN artifacts (YAML + test HTML). Present decision menu BEFORE generating implementation files (Phases 5-7).

### Phase 4.5: Present Design Decision Menu

**Stop here and present decision menu:**

```
✓ Mockup v[N] design created (2 files)

Files generated:
- v[N]-ui.yaml (design specification)
- v[N]-ui-test.html (browser-testable mockup)

What do you think?
1. Provide refinements (iterate on design) ← Creates v[N+1]
2. Finalize and create implementation files (recommended if satisfied)
3. Test in browser (open v[N]-ui-test.html)
4. Other
```

**WAIT for user response before continuing to Phase 5.**

- Option 1: User gives feedback → regenerate YAML + test HTML as new version
- Option 2: User approves → proceed to Phases 5-7 (generate remaining 5 files + parameter-spec.md)
- Option 3: Open test HTML in browser for interactive review
- Option 4: Handle custom request

**Only execute Phases 5-7 if user chose option 2 (finalize).**

### Phase 5: Generate Production HTML (After Finalization Only)

**Prerequisites:** User confirmed design in Phase 4.5 decision menu.

Creates production HTML with JUCE integration (same visual as test HTML, but with real parameter bindings):
- `v[N]-ui.html` - Production HTML (JUCE integrated)

### Phase 6: Generate C++ Boilerplate

**Prerequisites:** User confirmed design in Phase 4.5 decision menu.
Creates WebView implementation files:
- `v[N]-editor.h` - Header with relays and browser component
- `v[N]-editor.cpp` - Resource provider and parameter attachments

### Phase 7: Generate Build Configuration

**Prerequisites:** User confirmed design in Phase 4.5 decision menu.

Creates CMake snippets for:
- WebView feature flags
- ui/public/ directory zipping
- Binary embedding

### Phase 8: Generate Implementation Checklist

**Prerequisites:** User confirmed design in Phase 4.5 decision menu.

Creates step-by-step guide for Stage 5 implementation.

## What It Creates

**Two-phase file generation:**
- **Design phase (Phases 3-4):** 2 files (YAML spec + browser test HTML)
- **Implementation phase (Phases 5-8, after finalization):** 5 additional files

**Total per finalized mockup version: 7 files**

```
plugins/[PluginName]/.ideas/mockups/
├── v1-ui.yaml                      # Specification
├── v1-ui.html                      # Production HTML (JUCE integrated)
├── v1-ui-test.html                 # Browser test version (no JUCE)
├── v1-editor.h                     # C++ header boilerplate
├── v1-editor.cpp                   # C++ implementation boilerplate
├── v1-cmake.txt                    # CMakeLists.txt snippets
└── v1-implementation-steps.md      # Implementation checklist
```

## Versioning

Mockups increment with each iteration:
- First mockup: v1
- Redesign: v2
- Further iteration: v3, etc.

All versions preserved (idea lineage).

## Key Features

### Browser Testing
The `v[N]-ui-test.html` file works standalone in any browser:
- No JUCE needed
- Test layout, sizing, colors
- Verify control interactions
- Iterate rapidly without building

### Production Ready
The `v[N]-ui.html` file has complete JUCE integration:
- Parameter binding code
- Event handlers
- State management
- Ready to copy to `ui/public/index.html`

### Complete Boilerplate
The C++ files provide everything Stage 5 needs:
- WebSliderRelay declarations
- Browser component setup
- Resource provider implementation
- Parameter attachment initialization

Just customize parameter count and names.

## Integration

### Reads from:
- `plugins/[PluginName]/.ideas/creative-brief.md`
- `plugins/[PluginName]/.ideas/improvements/*.md`
- `plugins/[PluginName]/Source/PluginEditor.cpp` (for redesigns)

### Used by:
- `plugin-workflow` Stage 5 (reads mockup files for implementation)

### Offers to call:
- `design-sync` skill (if creative brief exists and needs updating)

## Iteration Process

**First mockup (v1) - Design Phase:**
1. Load creative brief
2. Conduct UI vision conversation
3. Generate design files: `v1-ui.yaml` + `v1-ui-test.html`
4. Present decision menu
5. User tests in browser or requests refinements

**Iteration (v2) - Still in Design Phase:**
1. User requests changes: "Add third knob for tone control"
2. System reads v1 as baseline
3. Generates v2 design files: `v2-ui.yaml` + `v2-ui-test.html`
4. Present decision menu again
5. Repeat until user chooses "finalize"

**Finalization - Implementation Phase:**
1. User chooses "finalize" from decision menu
2. System generates remaining 5 files for latest version
3. All implementation scaffolding ready for Stage 5

**Stage 5 finds latest version automatically.**

## Example Output Structure

For a simple gain plugin:

**v1-ui.yaml:**
```yaml
plugin_name: SimpleGain
window: { width: 400, height: 300 }
colors:
  background: "#2b2b2b"
  primary: "#4a9eff"
sections:
  main:
    components:
      - type: rotary_slider
        id: gain
        diameter: 70
```

**v1-ui.html:**
- Full HTML with styles
- JUCE JavaScript import
- Parameter bindings for 'gain'
- Ready to embed in plugin

**v1-editor.h:**
```cpp
juce::WebSliderRelay gainRelay { "gain" };

juce::WebBrowserComponent browser {
    juce::WebBrowserComponent::Options{}
        .withNativeIntegrationEnabled()
        .withOptionsFrom (gainRelay)
        .withResourceProvider ([this](...) { ... })
};

juce::WebSliderParameterAttachment gainAttachment;
```

## Validation

After generation, the skill validates:
- All 7 files exist
- HTML contains JUCE integration code (`getSliderState`)
- C++ has WebSliderRelay declarations
- Parameter names are consistent across files

## Best Practices

**Describe visual style early:** "Vintage tape machine aesthetic with warm colors" sets direction immediately.

**Reference specific dimensions:** "800x600 window" is clearer than "medium size".

**Mention layout preferences:** "Horizontal row of knobs" vs "vertical sliders" guides component choice.

**Test in browser first:** Open `v[N]-ui-test.html` before implementing to catch visual issues.

## Common Patterns

### Rotary Knob
- 70px diameter for primary controls
- Orange/blue accent colors popular
- Label below, value display optional

### Vertical Slider
- 160px tall for decay/time controls
- Track + thumb visual style
- Value display beside or below

### LED Indicator
- 12x12px with glow effect
- Shows voice activity or status
- Orange glow when active

### Grid Layout
- 3-4 columns for multi-parameter UIs
- 24px gaps between controls
- Centered alignment

## Reference

See working example: `plugins/WebViewGainPOC/`

Complete guide: `docs/webview-implementation-guide.md`
