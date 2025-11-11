# Changelog

All notable changes to FlutterVerb will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-11

### Added
- Initial release of FlutterVerb
- Plate reverb with SIZE and DECAY controls
- Wow and flutter modulation system (AGE parameter)
- Tape saturation with DRIVE control
- DJ-style filter with TONE control (-100% LP to +100% HP)
- MOD_MODE toggle (wet-only vs wet+dry modulation routing)
- Real-time VU meter with peak level display
- WebView UI with 6 knobs + toggle switch
- 7 factory presets showcasing different use cases

### Technical Details
- VST3 and AU formats
- Stereo processing
- JUCE 8 framework
- Real-time safe DSP implementation
- Thread-safe parameter communication
- Zero-latency processing (no look-ahead required)

### Features
- Dual LFO modulation (wow: 1Hz, flutter: 6Hz)
- Lagrange 3rd-order interpolation for smooth pitch modulation
- Exponential filter cutoff mapping for musical response
- VU meter ballistics (fast attack, slow release)
- Bypass zone for center filter position (transparent)
- State reset on filter type transitions (no burst artifacts)

### Known Limitations
- None at this time

[1.0.0]: https://github.com/yourusername/plugin-freedom-system/releases/tag/flutterverb-v1.0.0
