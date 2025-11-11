# Plugin Cleanup Workflows

Quick reference for removing plugins at different levels.

## Decision Tree

```
Need to clean up a plugin?
    │
    ├─ Just want to remove from DAW temporarily?
    │  └─ /uninstall [Name]
    │     • Removes: Binaries (VST3, AU)
    │     • Keeps: Source code
    │     • Status: 📦 Installed → ✅ Working
    │
    ├─ Implementation failed, but idea/mockups are good?
    │  └─ /reset-to-ideation [Name]
    │     • Removes: Source/, CMakeLists.txt, implementation docs, binaries
    │     • Keeps: creative-brief.md, mockups/, parameter-spec.md
    │     • Status: [Any] → 💡 Ideated
    │     • Next: /implement to start fresh from Stage 0
    │
    └─ Complete failure, never using this again?
       └─ /destroy [Name]
          • Removes: EVERYTHING (source, binaries, PLUGINS.md entry)
          • Keeps: Timestamped backup in backups/destroyed/
          • Status: Removed from registry
```

## Command Comparison

| Aspect | /uninstall | /reset-to-ideation | /destroy |
|--------|------------|-------------------|----------|
| **Source code** | ✅ Keep | ❌ Remove | ❌ Remove |
| **Binaries** | ❌ Remove | ❌ Remove | ❌ Remove |
| **Creative brief** | ✅ Keep | ✅ Keep | ❌ Remove |
| **Mockups** | ✅ Keep | ✅ Keep | ❌ Remove |
| **Parameter spec** | ✅ Keep | ✅ Keep | ❌ Remove |
| **PLUGINS.md entry** | ✅ Keep | ✅ Keep | ❌ Remove |
| **Backup created** | ❌ No | ✅ Yes | ✅ Yes |
| **Confirmation required** | ❌ No | ✅ Yes | ✅ Yes (type name) |
| **Reversible** | ✅ Reinstall | ✅ Restore backup | ✅ Restore backup |
| **Status change** | 📦 → ✅ | Any → 💡 | Removed |

## Use Case Examples

### Scenario 1: Testing Different Builds

**Situation:** Want to rebuild plugin with different compiler settings.

**Solution:**
```bash
/uninstall MyPlugin
# Modify build settings
# Rebuild via /continue
/install-plugin MyPlugin
```

**Why:** Only need to remove binaries temporarily. Source code unchanged.

---

### Scenario 2: Architecture Redesign

**Situation:** After Stage 2, realized the DSP architecture won't work. Need to redesign from Stage 0.

**Solution:**
```bash
/reset-to-ideation MyPlugin
# Reviews preserved mockups and creative brief
/implement MyPlugin
# Starts Stage 0 with fresh research, different architecture
```

**Why:** Idea and UI design are solid, just implementation approach was wrong.

---

### Scenario 3: Duplicate by Mistake

**Situation:** Accidentally created "GainKnob2" as duplicate of "GainKnob".

**Solution:**
```bash
/destroy GainKnob2
# Confirms by typing "GainKnob2"
```

**Why:** Complete mistake, no value in keeping anything. Clean removal.

---

### Scenario 4: Concept Was Flawed

**Situation:** Built "MagicalCompressor", turns out the concept doesn't make musical sense.

**Solution:**
```bash
/destroy MagicalCompressor
# Backup created in backups/destroyed/
```

**Why:** Fundamental concept is flawed. No point keeping idea or code.

---

### Scenario 5: Want Different UI Approach

**Situation:** Plugin works, but want to try completely different UI mockup.

**Solution:**
```bash
/reset-to-ideation MyPlugin
# Mockups preserved in .ideas/mockups/
# Create new v3 mockup
/implement MyPlugin
# Uses new mockup for implementation
```

**Why:** Code is outdated for new UI, but original mockups worth preserving for reference.

---

## Safety Features

### Confirmation Requirements

**None required:**
- `/uninstall` - Low risk, just removes binaries

**User confirmation (y/N):**
- `/reset-to-ideation` - Shows what's removed vs kept

**Type plugin name to confirm:**
- `/destroy` - Highest risk, requires exact name match

### Backup Locations

```
backups/
  rollbacks/              # /reset-to-ideation backups
    PluginName_YYYYMMDD_HHMMSS.tar.gz
  destroyed/              # /destroy backups
    PluginName_YYYYMMDD_HHMMSS.tar.gz
    PluginName_entry.md   # PLUGINS.md entry
```

**Retention:** Backups never auto-deleted. Manual cleanup if needed.

### Recovery

**From /reset-to-ideation:**
```bash
cd plugins/PluginName/
tar -xzf ../../backups/rollbacks/PluginName_TIMESTAMP.tar.gz --strip-components=1
# Update PLUGINS.md status manually
/continue PluginName
```

**From /destroy:**
```bash
cd plugins/
tar -xzf ../backups/destroyed/PluginName_TIMESTAMP.tar.gz
# Restore PLUGINS.md entry from PluginName_entry.md
/continue PluginName
```

## Blocked Operations

### Cannot /destroy if Status: 🚧

```
❌ Cannot destroy plugin in development (Status: 🚧 Stage 4)

Complete the workflow first:
- /continue PluginName - Resume and finish
- Or manually set status in PLUGINS.md if workflow abandoned
```

**Why:** Protects in-progress work from accidental deletion.

**Workaround:** Update PLUGINS.md status manually if workflow truly abandoned.

### Cannot /reset-to-ideation if No Creative Brief

```
❌ Cannot roll back: No creative brief found

This plugin has no ideation artifacts to preserve.
Use /destroy instead if you want to remove completely.
```

**Why:** No point resetting to ideation if there's nothing to preserve.

---

## Status Flow

```
💡 Ideated
    │
    ├─ /implement → 🚧 Stage N
    │                    │
    │                    ├─ /reset-to-ideation → 💡 Ideated
    │                    └─ Complete → ✅ Working
    │                                      │
    └─────────────────────────────────────┤
                                           │
                                           ├─ /install-plugin → 📦 Installed
                                           │                         │
                                           │                         └─ /uninstall → ✅ Working
                                           │
                                           └─ /destroy → [Removed]

From any state: /destroy → [Removed]
From 🚧: Cannot /destroy (must complete or manually change status)
From any state: /reset-to-ideation → 💡 Ideated
```

---

## Quick Reference Commands

```bash
# Temporary removal (keep source)
/uninstall PluginName

# Start over implementation (keep idea/mockups)
/reset-to-ideation PluginName

# Complete removal (backup created)
/destroy PluginName

# List all plugins and statuses
cat PLUGINS.md | grep "^###\|Status:"

# List backups
ls -lh backups/rollbacks/
ls -lh backups/destroyed/
```

---

## Notes

- All cleanup commands are logged in PLUGINS.md lifecycle timeline
- Backups include timestamp for tracking multiple rollbacks
- `/destroy` is the only command that removes PLUGINS.md entry
- DAW caches are always cleared when removing binaries
- Build artifacts are always removed with source code
