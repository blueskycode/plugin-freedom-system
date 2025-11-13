# Precondition Checks

## Contract Verification

Before starting Stage 2, verify all required planning documents exist:

```bash
# Check for architecture document (Stage 0 output)
test -f "plugins/$PLUGIN_NAME/.ideas/architecture.md"

# Check for implementation plan (Stage 1 output)
test -f "plugins/$PLUGIN_NAME/.ideas/plan.md"

# Check for creative brief (ideation output)
test -f "plugins/$PLUGIN_NAME/.ideas/creative-brief.md"
```

## Status Verification

Read PLUGINS.md to verify current plugin status:

```bash
# Extract plugin section
grep "^### $PLUGIN_NAME$" PLUGINS.md
```

Parse the Status line to determine current state:
- 📋 Planning → Planning just completed, OK to proceed
- 🔨 Building System → Implementation in progress, OK to resume
- 🎵 Processing Audio → DSP in progress, OK to resume
- 🎨 Designing Interface → UI in progress, OK to resume
- 💡 Concept Ready → Planning not started, BLOCK
- ✅ Ready to Install → Plugin complete, BLOCK (suggest /improve)
- 📦 Installed → Plugin deployed, BLOCK (suggest /improve)

## Block Messages

### Missing Contracts
```
Cannot start implementation - planning incomplete

[PluginName] is missing required planning documents:
- architecture.md (DSP design)
- plan.md (implementation strategy)
- creative-brief.md (vision document)

Complete planning first:
   Run /plan [PluginName] to create these documents

Then resume with /implement [PluginName]
```

### Wrong Status
```
[PluginName] needs planning before implementation.
Run /plan [PluginName] to complete stages 0-1.
```

OR

```
[PluginName] is already complete.
Use /improve [PluginName] to make changes.
```
