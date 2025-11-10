---
name: plugin-testing
description: Automated stability tests and validation suite
allowed-tools:
  - Read
  - Bash
  - Task # For deep-research on failures
preconditions:
  - Plugin must exist
  - Plugin status must NOT be 💡 (must have implementation)
---

# plugin-testing Skill

**Purpose:** Catch crashes, parameter issues, and state bugs in 2 minutes with automated tests.

## Three Test Modes

### Mode 1: Automated Testing (~2 min)

**Requirements:** `plugins/[Plugin]/Tests/` directory must exist with test infrastructure.

**When to use:** Quick stability check during development. Catches obvious bugs before building release binaries.

**Test infrastructure required:**

```cpp
// plugins/[Plugin]/Tests/StabilityTests.cpp
#include <catch2/catch_test_macros.hpp>
#include "../Source/PluginProcessor.h"

TEST_CASE("Parameter Response Test") {
    // Set parameters, process audio, verify output changes
}

TEST_CASE("State Save/Load Test") {
    // Save state, load state, verify parameters restore
}

// ... other tests
```

**5 automated tests:**

#### 1. Parameter Response Test

**Purpose:** Verify all parameters actually affect audio output.

**How it works:**

```cpp
TEST_CASE("Parameter Response Test") {
    [PluginName]Processor processor;
    processor.prepareToPlay(44100, 512);

    // Generate test signal (1kHz sine wave)
    juce::AudioBuffer<float> inputBuffer(2, 512);
    fillWithSineWave(inputBuffer, 1000.0f, 44100.0f);

    // For each parameter
    for (auto* param : processor.getParameters()) {
        // Test at min value
        param->setValueNotifyingHost(0.0f);
        auto outputMin = processBuffer(processor, inputBuffer);

        // Test at max value
        param->setValueNotifyingHost(1.0f);
        auto outputMax = processBuffer(processor, inputBuffer);

        // Verify output changed
        float rmsDifference = calculateRMSDifference(outputMin, outputMax);
        REQUIRE(rmsDifference > 0.001f);  // Some audible change
    }
}
```

**PASS:** All parameters cause measurable output change (RMS difference > 0.001)

**FAIL:** List parameters that don't affect audio

**Example failure:**

```
❌ Parameter Response Test FAILED

Non-responsive parameters:
- bypass (parameter index 5)
  Expected: Output should differ when bypass = 0 vs 1
  Actual: Identical output (RMS diff: 0.0)

  Likely cause: Parameter connected to APVTS but not used in processBlock()
```

**Common causes:**

- Parameter declared but not read in DSP code
- Wrong parameter ID in processBlock
- Parameter smoothing set to infinity (never reaches target)

#### 2. State Save/Load Test

**Purpose:** Verify plugin state persists correctly (DAW project save/load, preset recall).

**How it works:**

```cpp
TEST_CASE("State Save/Load Test") {
    [PluginName]Processor processor;

    // Set random parameter values
    juce::Random random;
    std::vector<float> originalValues;
    for (auto* param : processor.getParameters()) {
        float randomValue = random.nextFloat();
        param->setValueNotifyingHost(randomValue);
        originalValues.push_back(randomValue);
    }

    // Save state
    juce::MemoryBlock stateData;
    processor.getStateInformation(stateData);

    // Reset to defaults
    for (auto* param : processor.getParameters()) {
        param->setValueNotifyingHost(0.5f);
    }

    // Load state
    processor.setStateInformation(stateData.getData(), stateData.getSize());

    // Verify all parameters restored
    for (size_t i = 0; i < originalValues.size(); ++i) {
        float restored = processor.getParameters()[i]->getValue();
        REQUIRE(std::abs(restored - originalValues[i]) < 0.0001f);
    }
}
```

**PASS:** All parameters restore to exact values (within 0.0001 tolerance)

**FAIL:** List parameters that didn't restore correctly

**Example failure:**

```
❌ State Save/Load Test FAILED

Parameters not restoring:
- bypass (expected: 1.0, actual: 0.5, diff: 0.5)
- mix (expected: 0.73, actual: 0.5, diff: 0.23)

Likely causes:
- Parameters not saved in getStateInformation()
- Parameters not loaded in setStateInformation()
- Wrong parameter IDs in state save/load code
```

**Common causes:**

- Using raw AudioProcessor parameters instead of APVTS
- Typo in parameter ID during state load
- Missing parameters from XML state structure

#### 3. Silent Input Test

**Purpose:** Verify plugin doesn't add unexpected noise when fed silence.

**How it works:**

```cpp
TEST_CASE("Silent Input Test") {
    [PluginName]Processor processor;
    processor.prepareToPlay(44100, 512);

    // Generate silence
    juce::AudioBuffer<float> silentBuffer(2, 512);
    silentBuffer.clear();

    // Process silence
    processor.processBlock(silentBuffer, juce::MidiBuffer());

    // Check output RMS
    float outputRMS = calculateRMS(silentBuffer);

    // For clean processors (compressors, EQs)
    REQUIRE(outputRMS < 0.0001f);  // Essentially silent

    // For generators/effects that add noise
    REQUIRE(outputRMS < 0.1f);  // Reasonable noise floor
}
```

**PASS:** Output is silent OR reasonable for plugin type

**FAIL:** Unexpected output level

**Example failure:**

```
❌ Silent Input Test FAILED

Output RMS: 0.847 (expected < 0.0001)

This plugin adds significant output when input is silent.

Likely causes:
- Uninitialized audio buffers
- Denormal numbers causing CPU noise
- Oscillator/generator not gated properly
- Missing bypass logic
```

**Plugin type expectations:**

- **Clean processors** (compressor, EQ, limiter): Output should be silent (RMS < 0.0001)
- **Noisy processors** (analog-modeled saturation, tape): Some noise acceptable (RMS < 0.01)
- **Generators** (reverb, delay with feedback): Test disabled or threshold raised

**Common causes:**

- Uninitialized delay buffers containing garbage
- Denormal numbers in filters/reverbs
- Missing `clear()` in `prepareToPlay()`

#### 4. Feedback Loop Test

**Purpose:** Verify plugin doesn't explode (go to infinity) during processing.

**How it works:**

```cpp
TEST_CASE("Feedback Loop Test") {
    [PluginName]Processor processor;
    processor.prepareToPlay(44100, 512);

    // Generate test signal
    juce::AudioBuffer<float> testBuffer(2, 512);
    fillWithSineWave(testBuffer, 440.0f, 44100.0f);

    // Process 1000 iterations (simulating ~11 seconds of audio)
    float maxOutputSeen = 0.0f;
    for (int i = 0; i < 1000; ++i) {
        processor.processBlock(testBuffer, juce::MidiBuffer());
        maxOutputSeen = std::max(maxOutputSeen, findMaxAbsSample(testBuffer));

        // Early exit if exploding
        if (maxOutputSeen > 100.0f) {
            FAIL("Output exploding: " << maxOutputSeen);
        }

        // Reset input for next iteration
        fillWithSineWave(testBuffer, 440.0f, 44100.0f);
    }

    // Verify reasonable output level
    REQUIRE(maxOutputSeen < 10.0f);  // Allow some headroom above 0dBFS
}
```

**PASS:** Output RMS stays below threshold (< 10.0) over 1000 iterations

**FAIL:** Feedback or instability detected

**Example failure:**

```
❌ Feedback Loop Test FAILED

Iteration 247: Output = 87.3 (threshold: 10.0)

Plugin output is exploding during sustained processing.

Likely causes:
- Positive feedback in delay/reverb
- Unstable filter coefficients (poles outside unit circle)
- Gain multiplication without attenuation
- Missing hard clipping
```

**Common causes in different plugin types:**

- **Reverbs/delays**: Feedback parameter > 1.0 or summing without attenuation
- **Filters**: Unstable coefficients (resonance too high, wrong math)
- **Compressors**: Negative attack/release times, wrong gain reduction sign
- **General**: Accumulating values without bounds checking

#### 5. CPU Performance Test

**Purpose:** Verify plugin runs in real-time (doesn't exceed available CPU budget).

**How it works:**

```cpp
TEST_CASE("CPU Performance Test") {
    [PluginName]Processor processor;
    processor.prepareToPlay(44100, 512);

    juce::AudioBuffer<float> testBuffer(2, 512);
    fillWithSineWave(testBuffer, 1000.0f, 44100.0f);

    // Warm-up (let caches stabilize)
    for (int i = 0; i < 100; ++i) {
        processor.processBlock(testBuffer, juce::MidiBuffer());
    }

    // Measure processing time
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < 1000; ++i) {
        processor.processBlock(testBuffer, juce::MidiBuffer());
    }
    auto end = std::chrono::high_resolution_clock::now();

    double elapsedSeconds = std::chrono::duration<double>(end - start).count();
    double audioSeconds = (1000 * 512) / 44100.0;  // Time represented by 1000 buffers

    // Calculate real-time factor (should be < 1.0 for real-time)
    double realTimeFactor = elapsedSeconds / audioSeconds;

    // Allow 10% CPU usage (0.1 real-time factor)
    REQUIRE(realTimeFactor < 0.1);
}
```

**PASS:** Real-time factor < 0.1 (plugin uses < 10% of available CPU)

**FAIL:** Too CPU intensive

**Example failure:**

```
❌ CPU Performance Test FAILED

Real-time factor: 0.34 (expected < 0.1)

Plugin is too CPU intensive - using 34% of available processing time.

At 10ms buffer size (common in low-latency scenarios):
- Available: 10ms per buffer
- Plugin uses: 3.4ms per buffer
- Remaining for DAW/other plugins: 6.6ms

Performance budget exceeded by 240%.

Optimization suggestions:
- Profile with Instruments/perf to find hotspots
- Reduce filter order
- Use lookup tables for expensive functions (sin, exp, sqrt)
- Optimize inner loops (SIMD, remove branches)
```

**Real-time factor explanation:**

- **< 0.1**: Excellent (< 10% CPU usage)
- **0.1 - 0.3**: Good (10-30% CPU usage)
- **0.3 - 0.5**: Warning (30-50% CPU usage, may cause issues in complex projects)
- **> 0.5**: Fail (> 50% CPU usage, unusable in real-time)

**Performance benchmarks by plugin type:**

- **Simple utility** (gain, pan): < 0.01 real-time factor
- **Dynamics** (compressor, gate): < 0.05
- **EQ** (parametric, 4-8 bands): < 0.08
- **Time-based FX** (delay, chorus): < 0.10
- **Reverb** (algorithmic): < 0.15
- **Complex FX** (convolution reverb, spectral): < 0.30

### Running Automated Tests

**Invoke from command line:**

```bash
cd build
cmake .. -DBUILD_TESTS=ON
cmake --build . --target [PluginName]Tests
./Tests/[PluginName]Tests
```

**Expected output (all passing):**

```
Randomness seeded to: 1234567890

Running tests...
===============================================================================
All tests passed (5 assertions in 5 test cases)
```

**Report to user (success):**

```
✅ All tests PASSED (5/5)

Parameter response: PASS (5/5 parameters respond correctly)
State save/load: PASS (all parameters restore correctly)
Silent input: PASS (output RMS: 0.00002 - essentially silent)
Feedback test: PASS (max output over 1000 iterations: 1.2)
CPU performance: PASS (real-time factor: 0.03 - using 3% CPU)

Build: Release mode, macOS arm64, 44.1kHz, 512 samples
```

**Report to user (failures):**

```
❌ Tests FAILED (3/5 passed)

✅ Parameter response: PASS (5/5 parameters)
❌ State save/load: FAIL - Parameters not restoring: [bypass, mix]
✅ Silent input: PASS (output RMS: 0.0)
❌ Feedback test: FAIL - Output exploding (iteration 247, max: 87.3)
✅ CPU performance: PASS (real-time factor: 0.03)

What would you like to do?
1. Investigate failures (launch troubleshooting agents)
2. Show test code (see exact test implementation)
3. Show full test output (detailed logs)
4. I'll fix manually
5. Other

Choose (1-5): _
```

**Handling option 1 (Investigate failures):**

For each failed test, launch a `Task` agent with `deep-research` (Phase 7 feature - not yet implemented):

```
Investigating "State save/load" failure...

Running deep-research agent to find root cause...

[Agent searches for getStateInformation/setStateInformation implementations,
 checks parameter IDs, verifies APVTS usage, identifies missing parameters]

Root cause found: parameters/phase-1-plan.md:847

bypass parameter declared in PluginProcessor.h but not added to APVTS layout.

Fix: Add bypass parameter to createParameterLayout() function.
```

### Mode 2: Build + Pluginval (~5-10 min)

**When to use:** Before final testing or installation. Industry-standard validation (50+ tests).

**Pluginval:** Third-party validation tool by Tracktion (https://github.com/Tracktion/pluginval)

**What it tests:**

- **Plugin load/unload**: No crashes, memory leaks, global state
- **Parameter automation**: All parameters respond to automation
- **State recall**: Save/load works correctly
- **Thread safety**: No allocations in `processBlock()`, thread-safe state access
- **Audio validation**: Valid sample rates, buffer sizes, no silent outputs
- **Bus layouts**: Mono, stereo, sidechain configurations
- **MIDI handling**: Note on/off, CC, pitch bend
- **Preset handling**: Factory presets load correctly
- **UI validation**: Editor opens/closes without crashes

**Test strictness levels:**

- **5**: Basic validation (load/unload, process audio)
- **10**: Industry standard (recommended for release)
- **15**: Paranoid mode (extreme edge cases)

**Running pluginval:**

```bash
# Step 1: Build Release mode
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --parallel

# Step 2: Locate plugin binaries
VST3_PATH="build/plugins/$PLUGIN_NAME/${PLUGIN_NAME}_artefacts/Release/VST3/${PRODUCT_NAME}.vst3"
AU_PATH="build/plugins/$PLUGIN_NAME/${PLUGIN_NAME}_artefacts/Release/AU/${PRODUCT_NAME}.component"

# Step 3: Run pluginval on VST3
pluginval --validate "$VST3_PATH" \
          --strictness-level 10 \
          --timeout-ms 30000 \
          --verbose

# Step 4: Run pluginval on AU
pluginval --validate "$AU_PATH" \
          --strictness-level 10 \
          --timeout-ms 30000 \
          --verbose
```

**Expected output (all passing):**

```
Pluginval 1.0.3 - Plugin Validation

Testing: [ProductName].vst3

Running tests with strictness level 10...

[1/50] Loading plugin... PASS (23ms)
[2/50] Parameter validation... PASS (45ms)
[3/50] State save/load... PASS (67ms)
[4/50] Thread safety check... PASS (120ms)
...
[50/50] Memory leak detection... PASS (89ms)

===============================================================================
All tests PASSED (50/50)

Total time: 4.2s
```

**Report to user (success):**

```
✅ Build successful (Release mode)

Binaries:
- VST3: build/plugins/[Name]/[Name]_artefacts/Release/VST3/[Product].vst3 (2.4 MB)
- AU: build/plugins/[Name]/[Name]_artefacts/Release/AU/[Product].component (2.4 MB)

✅ Pluginval PASSED (strictness level 10)

VST3: All 50 tests passed
AU: All 50 tests passed

Total validation time: 8.7s

Plugin is ready for installation and real-world testing.
```

**Common pluginval failures:**

#### Parameter automation failure

```
❌ [12/50] Parameter automation... FAIL

Test: Automate all parameters
Issue: Parameter "threshold" does not respond to automation

Details:
- Set parameter via setParameter() → No audio change
- Expected: Automation should affect processBlock output
- Actual: Output unchanged

Fix: Verify parameter is read in processBlock() using apvts.getRawParameterValue()
```

#### Thread safety failure

```
❌ [23/50] Thread safety check... FAIL

Test: Detect allocations in processBlock()
Issue: Memory allocation detected during audio processing

Allocations:
- std::vector::resize() called in processBlock() (PluginProcessor.cpp:147)
- juce::String constructor (PluginProcessor.cpp:203)

Fix: Pre-allocate buffers in prepareToPlay(), never allocate in processBlock()
```

#### State recall failure

```
❌ [8/50] State save/load... FAIL

Test: Save state, change parameters, load state
Issue: Plugin state not restoring correctly

Parameters with incorrect values after load:
- bypass: expected 1.0, actual 0.5
- mix: expected 0.73, actual 0.5

Fix: Check getStateInformation() and setStateInformation() include all parameters
```

**Handling failures:**

```
✗ Pluginval FAILED (47/50 passed)

Failed tests:
- [8/50] State save/load: Plugin state not restoring correctly
- [23/50] Thread safety: Memory allocation in processBlock()
- [34/50] AU validation: Component not code-signed

What would you like to do?
1. Investigate failures (detailed analysis)
2. Show full pluginval output (complete logs)
3. Continue anyway (NOT RECOMMENDED - failures may cause crashes)
4. I'll fix manually
5. Other

Choose (1-5): _
```

**Option 1: Investigate failures**

For each failed test, provide:

- Explanation of what the test checks
- Why it matters (user impact)
- Specific fix recommendations
- File/line references if available

**Option 2: Show full pluginval output**

```bash
cat logs/[PluginName]/pluginval_[timestamp].log
```

Display complete output with ANSI colors preserved.

**Option 3: Continue anyway**

```
⚠️  WARNING: Continuing with pluginval failures is NOT RECOMMENDED

These failures may cause:
- Crashes in DAWs (Ableton, Logic, etc.)
- Rejected from plugin marketplaces
- Poor user experience (state loss, automation issues)

Recommended: Fix failures before installation.

Proceed anyway? (y/n): _
```

### Mode 3: Manual DAW Testing

**When to use:** Final validation before release. Automated tests can't catch everything (sonic quality, workflow, edge cases).

**Purpose:** Test plugin behavior in real DAW environment with real projects.

**Display comprehensive checklist:**

```markdown
# Manual DAW Testing Checklist for [PluginName]

**DAW:** [User specifies - Logic Pro, Ableton Live, etc.]
**Date:** [timestamp]

## Setup

- [ ] Open DAW
- [ ] Load plugin in audio track
- [ ] Open plugin UI
- [ ] Verify all controls visible and styled correctly
- [ ] Verify window size correct (not clipped or oversized)

## Parameter Testing

- [ ] Move each parameter slowly, verify audio changes smoothly
- [ ] Move parameters quickly, verify no zipper noise or clicks
- [ ] Verify parameter ranges (min/max values correct)
- [ ] Test extreme values (no crashes, audio doesn't explode)
- [ ] Verify parameter labels and units display correctly
- [ ] Test with different audio sources (drums, vocals, synths, full mix)

### Specific parameters to test:

[Auto-generate from parameter-spec.md]

- [ ] **threshold** (-60.0 to 0.0 dB): Test at extremes, verify compression behavior
- [ ] **ratio** (1.0 to 20.0): Test 1:1 (no compression) vs 20:1 (limiting)
- [ ] **attack** (0.1 to 100.0 ms): Fast attack should catch transients, slow should let them through
- [ ] **release** (10.0 to 1000.0 ms): Fast release should pump, slow should be smooth
- [ ] **gain** (0.0 to 24.0 dB): Verify makeup gain compensates for gain reduction
- [ ] **bypass** (on/off): Toggle while audio playing, verify no clicks or pops

## Automation

- [ ] Enable automation for key parameter (e.g., threshold)
- [ ] Draw automation curve (gradual sweep)
- [ ] Play back automation, verify plugin follows correctly
- [ ] Verify no lag or jumps in automation response
- [ ] Record parameter changes (twist knob during playback)
- [ ] Verify recorded automation plays back identically
- [ ] Test automation with multiple parameters simultaneously
- [ ] Verify parameter smoothing (no zipper noise during automation)

**Edge cases:**

- [ ] Jump automation from min to max instantly (no crash, reasonable smoothing)
- [ ] Automate rapidly (1ms resolution), verify CPU handles it
- [ ] Automate during buffer size changes (stress test)

## Preset Recall

- [ ] Set parameters to known values
- [ ] Save preset (e.g., "Aggressive Compression")
- [ ] Change all parameters to different values
- [ ] Load saved preset
- [ ] Verify all parameters restored exactly
- [ ] Test with multiple presets (save 3-5, load each, verify correctness)
- [ ] Test DAW's built-in preset system (if different from plugin's)

**Edge cases:**

- [ ] Load preset while audio playing (no clicks, instant parameter changes)
- [ ] Load preset during automation (verify automation overrides preset)
- [ ] Load very old preset (if plugin has legacy versions)

## Project Save/Load

- [ ] Configure plugin with specific parameter values
- [ ] Save DAW project
- [ ] Close DAW completely (not just project)
- [ ] Reopen DAW
- [ ] Open saved project
- [ ] Verify plugin loads with correct state
- [ ] Verify parameter values restored exactly
- [ ] Play audio, verify sonic result unchanged

**Edge cases:**

- [ ] Save project, change plugin version, reopen (backward compatibility)
- [ ] Save project on one machine, open on another (different CPU, OS version)
- [ ] Corrupted state (manually edit project file, verify plugin doesn't crash)

## Sample Rate Changes

- [ ] Test at 44.1 kHz (standard)
- [ ] Test at 48 kHz (video standard)
- [ ] Test at 96 kHz (high-resolution)
- [ ] Verify sonic character unchanged across sample rates
- [ ] Verify no crashes or glitches during sample rate switch
- [ ] Verify parameters remain valid (no scaling issues)

**DSP-specific tests:**

- **Filters**: Verify cutoff frequencies scale correctly
- **Time-based FX**: Verify delay times remain constant in milliseconds
- **Pitch-based**: Verify tuning remains correct (440 Hz = A4)

## Buffer Size Changes

- [ ] Test at 64 samples (low-latency)
- [ ] Test at 256 samples (typical)
- [ ] Test at 1024 samples (high-latency)
- [ ] Verify no crashes during buffer size switch
- [ ] Verify no audio dropouts or glitches
- [ ] Verify CPU usage scales appropriately (larger buffers = more efficient)
- [ ] Test with non-power-of-2 buffer sizes (e.g., 480 samples)

## Channel Configuration

- [ ] Test with mono input (single channel)
- [ ] Test with stereo input (L/R channels)
- [ ] Test with multichannel (if plugin supports 5.1, 7.1, etc.)
- [ ] Verify channel routing correct (no swapped L/R)
- [ ] Verify mono/stereo switch works correctly
- [ ] Test with mismatched I/O (mono in, stereo out)

**Stereo-specific tests:**

- [ ] Verify stereo image preserved (use width meter)
- [ ] Test with out-of-phase signals (L/R opposite polarity)
- [ ] Test with mono source panned hard left/right

## Edge Cases

- [ ] Silence input: Verify no added noise
- [ ] DC offset input: Verify plugin removes or handles correctly
- [ ] Clipped input (0 dBFS+): Verify no internal clipping artifacts
- [ ] Very low-level input (-60 dBFS): Verify no noise floor issues
- [ ] Change parameters rapidly (click spree): Verify no crashes
- [ ] Open/close UI repeatedly: Verify no memory leaks
- [ ] Load plugin in 10+ tracks simultaneously: Verify CPU remains reasonable

## Sonic Quality

- [ ] Load test signal (sine wave 1kHz, -12 dBFS)
- [ ] Process through plugin (with typical settings)
- [ ] Analyze output (spectrum analyzer, oscilloscope)
- [ ] Verify no unexpected harmonics or artifacts
- [ ] Verify output level correct (gain staging)

**Sine wave analysis:**

- [ ] Input: Clean sine wave (single fundamental frequency)
- [ ] Output: Should match expected behavior (e.g., compressor adds harmonics, EQ doesn't)
- [ ] No aliasing (no high-frequency artifacts above Nyquist)
- [ ] No DC offset (waveform centered at 0V)

- [ ] Load real audio (drums, vocal, mix)
- [ ] Process through plugin
- [ ] A/B test (bypass on/off)
- [ ] Verify sonic quality matches expectations
- [ ] Check for artifacts:
  - [ ] Digital clicks/pops
  - [ ] Zipper noise (parameter modulation)
  - [ ] Pre-ringing (linear-phase filters)
  - [ ] Pumping (compressor release too fast)
  - [ ] Comb filtering (phase issues)

## Stress Testing

- [ ] Leave plugin running for 1+ hour (check for memory leaks)
- [ ] Rapidly load/unload plugin 50+ times (check for resource cleanup)
- [ ] Max out all parameters (extreme settings, verify no crash)
- [ ] Process very loud input (+20 dBFS if possible) - verify no internal overflow
- [ ] Run with other CPU-intensive plugins (check for resource conflicts)

## Cross-DAW Testing (if time permits)

Test in 2-3 different DAWs to catch host-specific issues:

- [ ] Logic Pro (AU)
- [ ] Ableton Live (VST3)
- [ ] Reaper (VST3/AU)
- [ ] Pro Tools (AAX - if available)

Verify consistent behavior across all hosts.

## Final Verification

- [ ] All controls functional
- [ ] No crashes encountered
- [ ] No audio artifacts
- [ ] Parameter automation works
- [ ] Preset recall works
- [ ] Project save/load works
- [ ] Performance acceptable (CPU, latency)
- [ ] Sonic quality meets expectations

## Notes / Issues Found

[Free-form text area for user to note any issues]

---

**When complete, mark all items checked and confirm.**
```

**After user confirms checklist completion:**

```
✓ Manual DAW testing complete

What's next?
1. Mark plugin as tested and ready for release
2. Install plugin to system folders (/install-plugin)
3. Report issues found during testing
4. Run additional tests
5. Other

Choose (1-5): _
```

## Test Mode Selection

**When user invokes `/test [PluginName]` without specifying mode:**

```
How would you like to test [PluginName]?

1. Automated stability tests (~2 min)
   → Quick C++ unit tests (parameter response, state save/load, CPU usage)
   → Requires: Tests/ directory with Catch2 tests

2. Build + pluginval (~5-10 min) ⭐ RECOMMENDED
   → Industry-standard validation (50+ tests, strictness level 10)
   → Tests: Thread safety, automation, state recall, audio validation
   → Requires: Release build, pluginval installed

3. Manual DAW testing (~30-60 min)
   → Guided checklist for real-world testing
   → Tests: Sonic quality, workflow, edge cases in actual DAW

4. Skip testing (NOT RECOMMENDED)
   → Proceed to installation without validation

Choose (1-4): _
```

**Recommendation logic:**

- **If Tests/ directory exists:** Suggest option 1 first, then 2
- **If no Tests/ directory:** Recommend option 2 (pluginval)
- **Before final release:** Always run option 2 + 3

## Test Report Logging

**Save detailed logs for every test run:**

**Location:** `logs/[PluginName]/test_[timestamp].log`

**Log contents:**

```
================================================================================
Test Report: [PluginName]
================================================================================
Date: 2025-01-10 14:32:17
Mode: Build + Pluginval (strictness level 10)
Plugin: [PluginName] v1.0.0
Formats: VST3, AU

Build Configuration:
- Compiler: AppleClang 15.0.0
- Target: arm64 (Apple Silicon)
- Build type: Release
- Optimizations: -O3 -DNDEBUG

Build Results:
✅ VST3: plugins/[Name]/build/[Name].vst3 (2.4 MB)
✅ AU: plugins/[Name]/build/[Name].component (2.4 MB)
⏱️  Build time: 47s

Pluginval Results (VST3):
✅ All 50 tests PASSED
⏱️  Validation time: 4.2s

Pluginval Results (AU):
✅ All 50 tests PASSED
⏱️  Validation time: 4.5s

Total time: 56s

Conclusion: Plugin ready for installation
================================================================================

[Full pluginval output below]
...
```

**Log files are:**

- Auto-generated for every test run
- Timestamped for history tracking
- Referenced in failure investigation
- Useful for debugging issues later

## Integration Points

**Invoked by:**

- `/test [PluginName]` command → Mode selection menu
- `/test [PluginName] build` → Direct to mode 2 (build + pluginval)
- `/test [PluginName] quick` → Direct to mode 1 (automated tests)
- `/test [PluginName] manual` → Direct to mode 3 (DAW checklist)
- `plugin-workflow` skill → After Stages 4, 5, 6 (automated test at each stage)
- `plugin-improve` skill → After implementing changes
- Natural language: "Test [PluginName]", "Run validation on [PluginName]"

**Invokes (future):**

- `deep-research` skill (Phase 7) → When user chooses "Investigate failures"
- Launches `Task` agents to find root causes of test failures

**Creates:**

- Test logs in `logs/[PluginName]/test_[timestamp].log`
- Build artifacts in `build/plugins/[PluginName]/`

**Updates:**

- `.continue-here.md` → Marks testing complete, updates next step
- `PLUGINS.md` → Updates test status (last tested date, results)

**Blocks:**

- Installation (`/install-plugin`) → Recommends testing first if not done recently

## Decision Menu After Testing

**After automated tests pass:**

```
✓ All automated tests passed (5/5)

What's next?
1. Continue to next stage (if in workflow)
2. Run pluginval for industry-standard validation (recommended)
3. Install plugin (/install-plugin)
4. Review detailed test results
5. Other

Choose (1-5): _
```

**After pluginval passes:**

```
✓ Pluginval passed (50/50 tests, strictness level 10)

What's next?
1. Install plugin to system folders (recommended)
2. Run manual DAW testing checklist
3. Review full validation report
4. Build for distribution (future feature)
5. Other

Choose (1-5): _
```

**After manual testing complete:**

```
✓ Manual DAW testing complete

What's next?
1. Install plugin (/install-plugin) → Ready for production use
2. Mark plugin as release-ready (update PLUGINS.md status)
3. Report issues found (if any)
4. Run additional automated tests
5. Other

Choose (1-5): _
```

## Success Criteria

Testing is successful when:

- ✅ Tests run without crashes (even if some fail, process completes)
- ✅ All tests pass OR failures are documented with clear explanations
- ✅ User understands what failed and why (no mystery errors)
- ✅ Logs saved for future reference (`logs/[PluginName]/`)
- ✅ User knows next step (install, fix issues, continue workflow)
- ✅ Test results stored in PLUGINS.md (test date, pass/fail, mode used)

**NOT required for success:**

- 100% pass rate (failures are learning opportunities)
- Fixing all issues immediately (user can defer fixes)
- Running all 3 test modes (one mode is sufficient for validation)

## Common Issues and Solutions

**Issue:** Automated tests fail to compile

**Solution:**

```
Tests failed to compile:

Error: 'Catch2/catch_test_macros.hpp' file not found

This means Catch2 testing framework is not installed.

Fix options:
1. Skip automated tests, use pluginval instead (recommended)
2. Install Catch2: brew install catch2
3. Add Catch2 to CMakeLists.txt as FetchContent

Choose (1-3): _
```

**Issue:** Pluginval not found

**Solution:**

```
Pluginval not found in system PATH.

Pluginval is a third-party validation tool by Tracktion.

Install options:
1. Download from: https://github.com/Tracktion/pluginval/releases
2. Install via Homebrew: brew install pluginval
3. Skip pluginval, run automated tests instead

After installing, rerun: /test [PluginName] build

Choose (1-3): _
```

**Issue:** Plugin fails state save/load test

**Solution:**

```
State save/load test failed: Parameters not restoring correctly

Root cause: Using raw AudioProcessor parameters instead of APVTS

Fix:
1. Open PluginProcessor.h
2. Verify you have: juce::AudioProcessorValueTreeState apvts;
3. Open PluginProcessor.cpp
4. In getStateInformation():
   auto state = apvts.copyState();
   std::unique_ptr<juce::XmlElement> xml(state.createXml());
   copyXmlToBinary(*xml, destData);

5. In setStateInformation():
   std::unique_ptr<juce::XmlElement> xml(getXmlFromBinary(data, sizeInBytes));
   if (xml.get() != nullptr)
       apvts.replaceState(juce::ValueTree::fromXml(*xml));

This ensures APVTS handles all state management automatically.
```

**Issue:** Thread safety failure (allocations in processBlock)

**Solution:**

```
Thread safety test failed: Memory allocation detected in processBlock()

Location: PluginProcessor.cpp:147
Culprit: std::vector::resize()

Real-time audio rule: NEVER allocate memory in processBlock()

Fix:
1. Move all allocations to prepareToPlay():
   void prepareToPlay(double sampleRate, int samplesPerBlock) override {
       delayBuffer.setSize(2, 48000);  // Pre-allocate max size
   }

2. In processBlock(), only access pre-allocated buffers:
   void processBlock(juce::AudioBuffer<float>& buffer, ...) override {
       // No resize(), no new, no malloc()
       // Only use delayBuffer (already allocated)
   }

Common allocation sources:
- std::vector::resize()
- juce::String constructor
- std::make_unique()
- juce::AudioBuffer::setSize()

Rule: If it might allocate, move it to prepareToPlay().
```

**Issue:** User overwhelmed by too many test failures

**Solution:**

```
Multiple test failures detected (8/50 tests failed)

This is normal for initial testing - don't be discouraged.

Recommendation: Fix failures in priority order:

High priority (will cause crashes):
1. Thread safety failures → Fix first (real-time audio rule)
2. State save/load failures → Fix second (user data loss)

Medium priority (will cause issues):
3. Parameter automation failures → Fix third (workflow issues)
4. Audio validation failures → Fix fourth (sonic issues)

Low priority (nice to have):
5. Preset handling → Fix last (convenience)

Let's tackle them one at a time. Start with thread safety?

1. Yes, investigate thread safety failure
2. No, I'll fix manually
3. Show me all failures, I'll prioritize

Choose (1-3): _
```
