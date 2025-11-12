# Command Analysis Checklist

Track command optimization progress from analysis reports.

## Progress: 0/19 Complete

---

## Commands by Priority

### 🔴 Critical (Fix Immediately)

- [ ] **reconcile** (15/40) - Architecture violation: 409-line inline implementation, no frontmatter
- [ ] **install-plugin** (27/40) - Contains implementation details, 76% bloat
- [ ] **troubleshoot-juce** (N/A) - Deprecated, archive to save 400 tokens/session

### 🟡 High Priority (XML Enforcement Needed)

- [ ] **improve** (25/40) - Missing precondition enforcement, vagueness detection
- [ ] **reset-to-ideation** (24/40) - No precondition checks, token inefficiency
- [ ] **research** (23/40) - User docs instead of routing logic
- [ ] **dream** (30/40) - Routing logic not enforced, false preconditions
- [ ] **destroy** (31/40) - No validation for destructive operation
- [ ] **show-standalone** (28/40) - Missing allowed-tools declaration
- [ ] **sync-design** (30/40) - Preconditions not structurally enforced
- [ ] **test** (30/40) - Conditional routing unstructured
- [ ] **uninstall** (30/40) - Status checks lack XML enforcement

### 🟢 Low Priority (Minor Optimizations)

- [ ] **add-critical-pattern** (27/40) - Add XML preconditions, consolidate prose
- [ ] **doc-fix** (34/40) - Add argument-hint, minor optimizations
- [ ] **implement** (35/40) - Condense error messages, add XML
- [ ] **plan** (30/40) - XML status verification, token consolidation

### ✅ Excellent (Reference Examples)

- [ ] **setup** (38/40) - Near-perfect routing layer
- [ ] **continue** (38/40) - Ideal delegation pattern
- [ ] **clean** (38/40) - Status-aware menu logic

---

## Aggregate Statistics

**Token Savings Potential:** ~6,950 tokens (estimated 30% reduction system-wide)

**Critical Issues Identified:** 28 across all commands
- Missing XML enforcement: 16 commands
- Frontmatter issues: 7 commands
- Documentation bloat: 12 commands
- Architecture violations: 2 commands

**Implementation Time Estimate:** ~16 hours total
- Critical fixes: 6 hours
- High priority: 8 hours
- Low priority: 2 hours

---

## Analysis Reports Location

All reports in: `./command-analysis/`

Report naming: `[command-name]-analysis.md`

---

## Usage

For each command:
1. Read analysis report at `./command-analysis/[name]-analysis.md`
2. Implement fixes from "Critical Issues" section
3. Apply optimizations from "Optimization Opportunities" section
4. Run verification checklist from report
5. Check off command in list above

---

## Systemic Patterns to Address

1. **XML Enforcement Standard** - Create template for `<preconditions enforcement="blocking">` pattern
2. **Frontmatter Standardization** - Fix all `args` → `argument-hint` conversions
3. **Command/Skill Boundary** - Extract implementation details from commands to skills
4. **Documentation Extraction** - Move examples/outputs to skill docs for progressive disclosure

---

## Next Steps

1. **Immediate:** Fix reconcile.md architecture violation (convert to skill)
2. **Batch 1:** Add XML precondition enforcement to 16 commands (use template)
3. **Batch 2:** Standardize frontmatter across all commands
4. **Batch 3:** Extract documentation bloat to skill references
5. **Final:** Archive troubleshoot-juce.md
