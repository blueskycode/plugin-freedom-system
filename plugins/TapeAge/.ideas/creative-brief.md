# TAPE AGE - Creative Brief

## Overview

**Type:** Audio Effect (Tape Saturator)
**Core Concept:** Vintage tape saturation with musical degradation
**Status:** 💡 Ideated
**Created:** 2025-11-10

## Vision

TAPE AGE is a vintage tape saturator that captures the warmth and character of 60s/70s tape machines. It combines smooth saturation with controllable tape degradation—wow, flutter, dropout, and noise—all tuned to remain musical even at maximum settings. The plugin delivers warm lo-fi saturation with authentic tape artifacts, designed for adding vintage character without crossing into unusable territory.

## Parameters

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| DRIVE | 0-100% | 50% | Tape saturation amount—warm harmonic distortion |
| AGE | 0-100% | 25% | Tape degradation (wow/flutter/dropout/noise)—max = very old but musical |
| MIX | 0-100% | 100% | Dry/wet blend |

## UI Concept

**Layout:**
- Medium rectangle (nearly square dimensions)
- Top section: Vintage VU meter with moving needle (output level, peak metering)
- Center: "TAPE AGE" title in clean sans-serif, all caps, generous letter spacing
- Bottom section: 3 brass knobs in horizontal row (DRIVE, AGE, MIX)
- Labels below each knob in all caps

**Visual Style:**
- Background: Slightly textured creamy beige
- Color palette: Cream/beige base with burnt orange and brown accents
- Typography: Clean sans-serif, all caps, spacious letter spacing
- Knobs: Realistic vintage brass-colored knobs with pointer line indicators (no numeric values)
- Subtle shadow and depth on knobs for dimensionality

**Key Elements:**
- Vintage VU meter with authentic needle movement
- Brass vintage-style knobs with position indicators
- 60s/70s tape machine aesthetic with earth tone palette
- Centered, balanced layout—everything feels intentional and beautiful

## Use Cases

- Adding warmth and character to digital recordings
- Lo-fi processing for vocals, drums, or full mixes
- Vintage tape simulation for retro productions
- Subtle saturation (low Drive/Age) or heavy degradation (high settings)
- Parallel processing with Mix control for blend flexibility

## Inspirations

- 60s/70s tape machines (visual and sonic reference)
- Warm tape saturation with lo-fi character
- Musical degradation that remains usable at extremes

## Technical Notes

**AGE parameter controls multiple tape artifacts:**
- Wow (slow pitch variations)
- Flutter (fast pitch variations)
- Tape dropout (intermittent signal loss)
- Tape noise (hiss and character)

**Design constraint:** Maximum AGE setting should sound "very old and degraded" but never "stupid"—all artifacts remain musical and intentional.

**Saturation character:** Warm harmonic distortion, lo-fi edge, tape compression behavior.

## Next Steps

- [ ] Create UI mockup (`/dream TapeAge` → option 3)
- [ ] Start implementation (`/implement TapeAge`)
