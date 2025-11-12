# DrumRoulette - Creative Brief

## Overview

**Type:** Instrument
**Core Concept:** Eight-slot drum sampler with folder-based randomization and mixer-style interface
**Status:** 💡 Ideated
**Created:** 2025-11-12

## Vision

DrumRoulette is a drum sampler designed around creative exploration through controlled randomization. Each of the eight sample slots connects to a folder on your computer, allowing you to randomize individual sounds or the entire kit while maintaining creative control through per-channel lock buttons. The interface resembles a mixing console, with eight vertical channel strips providing immediate access to essential drum processing controls.

The plugin emphasizes drum-specific parameter design: decay controls tighten or lengthen sounds without sustain, attack times are tailored for percussive shaping, and a tilt filter provides intuitive brightness control. Multi-output routing enables advanced production workflows, allowing each drum to be processed independently in your DAW.

## Parameters

### Global Controls
| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| Randomize All | Button | - | Randomize all unlocked slots simultaneously |

### Per-Slot Controls (×8)
| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| Folder Path | File Browser | Empty | Select folder containing audio samples |
| Randomize | Button | - | Pick random sample from assigned folder |
| Lock | Toggle | Off | Exclude slot from global randomization |
| Volume | Fader (-inf to +6dB) | 0dB | Channel level control |
| Decay | 10ms - 2s | 500ms | Envelope decay time (sustain always 0) |
| Attack | 0 - 50ms | 1ms | Envelope attack time for percussive shaping |
| Tilt Filter | -12dB to +12dB | 0dB | Brightness control (pivot at 1kHz) |
| Pitch | ±12 semitones | 0 | Pitch shift in semitones |
| Solo | Toggle | Off | Solo this channel |
| Mute | Toggle | Off | Mute this channel |
| Output Routing | Dropdown | Main | Route to Main or Individual Out 1-8 |

## UI Concept

**Layout:** Eight vertical channel strips arranged horizontally, resembling a mixing console
**Visual Style:** Clean, functional mixer aesthetic with clear visual hierarchy
**Key Elements:**
- LED-style trigger indicators per channel (illuminate when sound plays)
- Color-coded lock icons (grey when unlocked, highlighted when locked)
- Waveform thumbnails or sample names visible in each strip
- Global randomize button prominently placed
- Folder browser accessible per channel
- Fader-style volume controls for tactile mixing

## Use Cases

- **Rapid beat sketching:** Quickly explore variations by randomizing drum kits from curated sample folders
- **Live performance:** Lock favorite sounds while improvising with randomization on other slots
- **Sample discovery:** Browse large sample libraries by rapidly randomizing through folders
- **Parallel processing:** Route individual drums to separate DAW channels for advanced mixing and effects
- **Creative constraints:** Use limited sample folders with randomization to inspire unexpected combinations

## Inspirations

- Mixing console workflow (SSL, Neve) for interface layout
- Battery/Geist for multi-slot drum sampling approach
- Randomization features in modern production tools
- Hardware drum machines with per-voice outputs

## Technical Notes

**Audio Engine:**
- True random file selection from folders (any file each time)
- Recursive folder scanning (includes subfolders)
- Support for WAV, AIFF, MP3, and AAC formats
- Sample playback with ADSR envelope (sustain fixed at 0 for decay-focused control)
- Tilt filter centered at 1kHz for intuitive brightness/darkness control
- Pitch shifting ±12 semitones

**MIDI Implementation:**
- Eight slots mapped to C1-G1 (chromatic)
- Standard MIDI velocity response

**Audio Routing:**
- Stereo main output (mix of all channels)
- 8 individual stereo outputs (one per slot)
- 18 total outputs (2 main + 16 individual)

**File Handling:**
- Error messages when folders contain no valid audio files
- Manual folder selection each session (no persistence)
- Folder path stored with project for recall

**Randomization Logic:**
- Per-channel randomize buttons
- Global randomize button (affects all unlocked slots)
- Lock buttons exclude specific slots from global randomization
- True random selection (no shuffle/cycle behavior)

## Next Steps

- [ ] Create UI mockup (`/dream DrumRoulette` → option 3)
- [ ] Start implementation (`/implement DrumRoulette`)
