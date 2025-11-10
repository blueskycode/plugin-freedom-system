# TapeAge - Parameter Specification

**Plugin:** TapeAge (Vintage Tape Saturator)
**Version:** 1.0
**Generated:** 2025-11-10

---

## CONTRACT STATUS

**CRITICAL:** This file is immutable during implementation (Stages 2-5).

This specification is the single source of truth for all parameters. Changes require full system review and version bump.

---

## Parameters

| ID    | Type  | Range      | Default | Skew | Unit | UI Control    | DSP Usage                              |
|-------|-------|------------|---------|------|------|---------------|----------------------------------------|
| drive | Float | [0.0, 1.0] | 0.5     | 1.0  | %    | Rotary Slider | Tape saturation amount (harmonic distortion) |
| age   | Float | [0.0, 1.0] | 0.25    | 1.0  | %    | Rotary Slider | Tape degradation (wow/flutter/dropout/noise) |
| mix   | Float | [0.0, 1.0] | 1.0     | 1.0  | %    | Rotary Slider | Dry/wet blend                          |

---

## Parameter Details

### 1. DRIVE

- **ID:** `drive`
- **Type:** Float (normalized 0.0 to 1.0)
- **Range:** 0% (no saturation) to 100% (maximum saturation)
- **Default:** 50%
- **Skew Factor:** 1.0 (linear)
- **UI Control:** Brass rotary knob
- **Label:** "DRIVE"

**DSP Behavior:**
- Controls tape saturation intensity
- Adds warm harmonic distortion
- Simulates tape compression at higher values
- Should remain musical across full range

**Implementation Notes:**
- Map 0.0-1.0 to saturation algorithm gain parameter
- Consider logarithmic scaling for more natural feel
- Interact with AGE parameter for combined tape character

---

### 2. AGE

- **ID:** `age`
- **Type:** Float (normalized 0.0 to 1.0)
- **Range:** 0% (new tape) to 100% (very old tape)
- **Default:** 25%
- **Skew Factor:** 1.0 (linear)
- **UI Control:** Brass rotary knob
- **Label:** "AGE"

**DSP Behavior:**
- Controls tape degradation artifacts
- 0%: Clean tape (no artifacts)
- 100%: Very old tape (maximum artifacts, but still musical)

**Artifact Components Controlled:**
1. **Wow:** Slow pitch variations (< 1 Hz)
2. **Flutter:** Fast pitch variations (5-10 Hz)
3. **Dropout:** Intermittent signal loss/attenuation
4. **Noise:** Tape hiss and character

**Implementation Notes:**
- All artifacts scale proportionally with AGE value
- Maximum AGE must sound "very old" but never "stupid"
- Artifacts should remain musical and intentional at all settings
- Consider subtle randomization for organic feel

---

### 3. MIX

- **ID:** `mix`
- **Type:** Float (normalized 0.0 to 1.0)
- **Range:** 0% (100% dry) to 100% (100% wet)
- **Default:** 100%
- **Skew Factor:** 1.0 (linear)
- **UI Control:** Brass rotary knob
- **Label:** "MIX"

**DSP Behavior:**
- Blends dry (unprocessed) and wet (processed) signals
- 0%: Bypass (dry signal only)
- 100%: Full effect (wet signal only)
- Enables parallel processing techniques

**Implementation Notes:**
- Use equal-power crossfade for smooth blending
- Ensure no phase cancellation at 50% mix
- Latency compensation if processing introduces delay

---

## Parameter Relationships

### Drive × Age Interaction
- Higher DRIVE + higher AGE = more pronounced tape artifacts
- Low DRIVE + high AGE = clean signal with degradation
- High DRIVE + low AGE = clean saturation without artifacts

### Mix Processing
- MIX applies AFTER Drive and Age processing
- Allows subtle blending for transparent tape coloration
- Useful for parallel compression workflows

---

## JUCE Implementation

### Parameter Creation (PluginProcessor.cpp)

```cpp
juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout()
{
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;

    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "drive",
        "Drive",
        juce::NormalisableRange<float>(0.0f, 1.0f, 0.01f),
        0.5f,
        juce::String(),
        juce::AudioProcessorParameter::genericParameter,
        [](float value, int) { return juce::String(static_cast<int>(value * 100)) + "%"; }
    ));

    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "age",
        "Age",
        juce::NormalisableRange<float>(0.0f, 1.0f, 0.01f),
        0.25f,
        juce::String(),
        juce::AudioProcessorParameter::genericParameter,
        [](float value, int) { return juce::String(static_cast<int>(value * 100)) + "%"; }
    ));

    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        "mix",
        "Mix",
        juce::NormalisableRange<float>(0.0f, 1.0f, 0.01f),
        1.0f,
        juce::String(),
        juce::AudioProcessorParameter::genericParameter,
        [](float value, int) { return juce::String(static_cast<int>(value * 100)) + "%"; }
    ));

    return { params.begin(), params.end() };
}
```

### Parameter Access (DSP)

```cpp
void processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer&)
{
    auto drive = parameters.getRawParameterValue("drive")->load();
    auto age = parameters.getRawParameterValue("age")->load();
    auto mix = parameters.getRawParameterValue("mix")->load();

    // Use parameters in DSP processing...
}
```

---

## Automation & Modulation

All parameters support:
- ✅ DAW automation (write/read)
- ✅ MIDI CC mapping (if implemented)
- ✅ Real-time modulation
- ✅ Smooth parameter changes (no zipper noise)

---

## State Persistence

Parameters are saved/restored via:
- DAW session state
- Plugin preset files
- JUCE `AudioProcessorValueTreeState`

---

## Validation

**Stage 1 (Planning) blocks if:**
- This file is missing
- Parameter IDs don't match UI mockup
- Range/default values are inconsistent

**Stage 2-5 (Implementation) rules:**
- This spec is IMMUTABLE
- All stages reference these exact parameters
- No drift allowed between stages

---

## Future Extensions (Post-v1.0)

Potential parameters for future versions:
- Output gain/trim
- Tape speed (IPS selection)
- Bias control (frequency response curve)
- Stereo width modulation

**Note:** These require new spec version and full workflow restart.
