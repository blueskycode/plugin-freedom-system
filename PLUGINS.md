# PLUGIN REGISTRY

## State Legend

- **💡 Ideated** - Creative brief exists, no implementation
- **🚧 Stage N** - In development (specific stage number)
- **✅ Working** - Completed Stage 6, not installed
- **📦 Installed** - Deployed to system folders
- **🐛 Has Issues** - Known problems (combines with other states)
- **🗑️ Archived** - Deprecated

## State Machine Rules

**CRITICAL:** Only ONE plugin can be 🚧 at a time (prevents concurrent modification bugs)

- If status is 🚧: ONLY plugin-workflow can modify (use `/continue` to resume)
- plugin-improve blocks if status is 🚧 (must complete workflow first)

## Plugin Registry

| Plugin Name | Status | Version | Last Updated |
|-------------|--------|---------|--------------|
| TapeAge | 💡 Ideated | - | 2025-11-10 |

### TapeAge

**Status:** 💡 **Ideated**
**Created:** 2025-11-10
**Type:** Audio Effect

**Description:**
Vintage tape saturator with warm saturation and musical degradation (wow/flutter/dropout/noise). 60s/70s aesthetic with earth tone palette.

**Parameters (3 total):**
- DRIVE: 0-100%, default 50% (tape saturation)
- AGE: 0-100%, default 25% (tape degradation - wow/flutter/dropout/noise)
- MIX: 0-100%, default 100% (dry/wet blend)

**DSP:** Warm harmonic saturation with controllable tape artifacts (wow, flutter, dropout, noise). Musical degradation even at maximum settings.

**GUI:** Medium rectangle, vintage VU meter (output peak), 3 brass knobs horizontal, creamy beige textured background, burnt orange/brown accents, clean sans-serif all-caps typography.

**Lifecycle Timeline:**
- **2025-11-10:** Creative brief completed

**Known Issues:**
- None

**Last Updated:** 2025-11-10

## Entry Template

```markdown
### [PluginName]
**Status:** [Emoji] **[State Name]**
**Created:** YYYY-MM-DD
**Version:** X.Y.Z (if applicable)
**Type:** [Audio Effect | MIDI Instrument | Synth]

**Description:**
[Brief description]

**Parameters ([N] total):**
- [Param1]: [range], default [value]
- [Param2]: [range], default [value]

**DSP:** [Architecture description]

**GUI:** [Design description]

**Lifecycle Timeline:**
- **YYYY-MM-DD (Stage 0):** Research completed
- **YYYY-MM-DD (Stage 1):** Planning - Complexity N

**Known Issues:**
- None

**Last Updated:** YYYY-MM-DD
```
