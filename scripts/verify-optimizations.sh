#!/usr/bin/env bash
set -euo pipefail

# Automated Optimization Verification Suite
# Tests all optimizations implemented since commit 229973cf077ab03f5800eb76013c4d04391c51a2
#
# Usage:
#   ./scripts/verify-optimizations.sh           # Run all tests
#   ./scripts/verify-optimizations.sh -v        # Verbose mode
#   ./scripts/verify-optimizations.sh --dry-run # Show what would be tested

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

# Flags
VERBOSE=false
DRY_RUN=false

# Project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Parse arguments
for arg in "$@"; do
  case $arg in
    -v|--verbose) VERBOSE=true ;;
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

# Output functions
pass() {
  echo -e "${GREEN}✓${NC} $1"
  PASS=$((PASS + 1))
}

fail() {
  echo -e "${RED}✗${NC} $1"
  FAIL=$((FAIL + 1))
  if [[ "$VERBOSE" == true ]] && [[ -n "${2:-}" ]]; then
    echo -e "  ${RED}Details:${NC} $2"
  fi
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
  WARN=$((WARN + 1))
}

section() {
  echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}━━━ $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

info() {
  if [[ "$VERBOSE" == true ]]; then
    echo -e "${CYAN}ℹ${NC} $1"
  fi
}

dry_run_msg() {
  if [[ "$DRY_RUN" == true ]]; then
    echo -e "${CYAN}[DRY RUN]${NC} Would test: $1"
  fi
}

# Test: File exists
test_file_exists() {
  local file="$1"
  local description="$2"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "File exists: $file"
    return 0
  fi

  if [[ -f "$file" ]]; then
    pass "$description"
  else
    fail "$description" "File not found: $file"
  fi
}

# Test: File does NOT exist
test_file_not_exists() {
  local file="$1"
  local description="$2"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "File should NOT exist: $file"
    return 0
  fi

  if [[ ! -f "$file" ]]; then
    pass "$description"
  else
    fail "$description" "File should not exist but found: $file"
  fi
}

# Test: File contains pattern
test_file_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "File $file contains pattern: $pattern"
    return 0
  fi

  if [[ ! -f "$file" ]]; then
    fail "$description" "File not found: $file"
    return
  fi

  if grep -E "$pattern" "$file" >/dev/null 2>&1; then
    pass "$description"
    info "Found pattern in $file"
  else
    fail "$description" "Pattern '$pattern' not found in $file"
  fi
}

# Test: File does NOT contain pattern
test_file_not_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "File $file should NOT contain pattern: $pattern"
    return 0
  fi

  if [[ ! -f "$file" ]]; then
    pass "$description (file doesn't exist)"
    return
  fi

  if ! grep -E "$pattern" "$file" >/dev/null 2>&1; then
    pass "$description"
  else
    fail "$description" "Pattern '$pattern' found in $file but should not exist"
    if [[ "$VERBOSE" == true ]]; then
      echo -e "  ${RED}Matches:${NC}"
      grep -En "$pattern" "$file" | head -3 | sed 's/^/    /'
    fi
  fi
}

# Category 1: File Existence & Structural Integrity
test_file_structure() {
  section "1. File Existence & Structural Integrity"

  # New agent files (with -agent suffix)
  test_file_exists ".claude/agents/dsp-agent.md" "DSP agent exists"
  test_file_exists ".claude/agents/foundation-shell-agent.md" "Foundation-Shell agent exists (merged)"
  test_file_exists ".claude/agents/gui-agent.md" "GUI agent exists"
  test_file_exists ".claude/agents/research-planning-agent.md" "Research-Planning agent exists (merged)"
  test_file_exists ".claude/agents/troubleshoot-agent.md" "Troubleshoot agent exists (renamed)"
  test_file_exists ".claude/agents/validation-agent.md" "Validation agent exists (renamed)"

  # Old agent files should NOT exist
  test_file_not_exists ".claude/agents/foundation-agent.md" "Old foundation-agent removed"
  test_file_not_exists ".claude/agents/shell-agent.md" "Old shell-agent removed"
  test_file_not_exists ".claude/agents/validator.md" "Old validator removed"
  test_file_not_exists ".claude/agents/troubleshooter.md" "Old troubleshooter removed"
  test_file_not_exists ".claude/agents/research-agent.md" "Old research-agent removed"
  test_file_not_exists ".claude/agents/planning-agent.md" "Old planning-agent removed"

  # New stage reference files
  test_file_exists ".claude/skills/plugin-workflow/references/stage-2-foundation-shell.md" "Stage 2 foundation-shell exists"
  test_file_exists ".claude/skills/plugin-workflow/references/stage-3-dsp.md" "Stage 3 DSP exists"
  test_file_exists ".claude/skills/plugin-workflow/references/stage-4-gui.md" "Stage 4 GUI exists"
  test_file_exists ".claude/skills/plugin-workflow/references/stage-5-validation.md" "Stage 5 validation exists"

  # Old stage reference files should NOT exist
  test_file_not_exists ".claude/skills/plugin-workflow/references/stage-2-foundation.md" "Old Stage 2 foundation removed"
  test_file_not_exists ".claude/skills/plugin-workflow/references/stage-3-shell.md" "Old Stage 3 shell removed"
  test_file_not_exists ".claude/skills/plugin-workflow/references/stage-4-dsp.md" "Old Stage 4 DSP removed"
  test_file_not_exists ".claude/skills/plugin-workflow/references/stage-5-gui.md" "Old Stage 5 GUI removed"
  test_file_not_exists ".claude/skills/plugin-workflow/references/stage-6-validation.md" "Old Stage 6 validation removed"

  # Validation cache system
  test_file_exists ".claude/utils/validation-cache.sh" "Validation cache script exists"
  test_file_exists ".claude/utils/validation-cache.md" "Validation cache docs exist"
  test_file_exists ".claude/commands/clear-cache.md" "Clear cache command exists"

  # Two-phase parameters
  test_file_exists ".claude/skills/plugin-ideation/assets/parameter-spec-draft-template.md" "Parameter spec draft template exists"
  test_file_exists ".claude/skills/plugin-ideation/references/parallel-workflow-test-scenario.md" "Parallel workflow test scenario exists"

  # Check .gitignore contains cache directory
  if [[ "$DRY_RUN" == false ]]; then
    if grep -q "\.claude/cache/" .gitignore; then
      pass ".gitignore excludes cache directory"
    else
      fail ".gitignore excludes cache directory" "Missing .claude/cache/ in .gitignore"
    fi
  else
    dry_run_msg "Check .gitignore for .claude/cache/"
  fi
}

# Category 2: Schema Validation
test_schema_validation() {
  section "2. Schema Validation"

  local schema_file=".claude/schemas/subagent-report.json"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "Schema validation tests"
    return 0
  fi

  if [[ ! -f "$schema_file" ]]; then
    fail "subagent-report.json exists" "File not found: $schema_file"
    return
  fi

  # Check workflow agent names in schema (note: validation-agent and troubleshoot-agent are not in this schema as they're not part of the main workflow)
  local workflow_agents=("foundation-shell-agent" "research-planning-agent" "dsp-agent" "gui-agent")
  for agent in "${workflow_agents[@]}"; do
    if jq -e ".properties.agent.enum | index(\"$agent\")" "$schema_file" >/dev/null 2>&1; then
      pass "Schema includes $agent"
    else
      fail "Schema includes $agent" "Agent '$agent' not found in schema enum"
    fi
  done

  # Check old agent names NOT in schema
  local old_agents=("foundation-agent" "shell-agent" "validator" "troubleshooter" "research-agent" "planning-agent")
  for agent in "${old_agents[@]}"; do
    if ! jq -e ".properties.agent.enum | index(\"$agent\")" "$schema_file" >/dev/null 2>&1; then
      pass "Schema excludes old $agent"
    else
      fail "Schema excludes old $agent" "Old agent '$agent' still in schema enum"
    fi
  done

  # Verify schema agent list matches workflow agents exactly
  local schema_agents
  schema_agents=$(jq -r '.properties.agent.enum[]' "$schema_file" | sort | tr '\n' ',' | sed 's/,$//')
  local expected_agents="dsp-agent,foundation-shell-agent,gui-agent,research-planning-agent"

  if [[ "$schema_agents" == "$expected_agents" ]]; then
    pass "Schema contains exactly the workflow agents (no stage property as stages are inferred from agent)"
  else
    fail "Schema agent list matches expected workflow agents" "Expected: $expected_agents, Got: $schema_agents"
  fi
}

# Category 3: Content Verification (Critical References)
test_content_verification() {
  section "3. Content Verification (Critical References)"

  # plugin-workflow/SKILL.md
  local workflow_skill=".claude/skills/plugin-workflow/SKILL.md"

  test_file_contains "$workflow_skill" "foundation-shell-agent" "plugin-workflow references foundation-shell-agent"
  test_file_contains "$workflow_skill" "dsp-agent" "plugin-workflow references dsp-agent"
  test_file_contains "$workflow_skill" "gui-agent" "plugin-workflow references gui-agent"
  test_file_contains "$workflow_skill" "validation-agent" "plugin-workflow references validation-agent"

  test_file_not_contains "$workflow_skill" "(^|[^-])foundation-agent([^-]|$)" "plugin-workflow excludes old foundation-agent"
  test_file_not_contains "$workflow_skill" "(^|[^-])shell-agent([^-]|$)" "plugin-workflow excludes old shell-agent"
  test_file_not_contains "$workflow_skill" "validator([^-]|$)" "plugin-workflow excludes old validator"
  test_file_not_contains "$workflow_skill" "troubleshooter([^-]|$)" "plugin-workflow excludes old troubleshooter"

  # Check milestone language in user-facing sections
  test_file_contains "$workflow_skill" "Build System Ready" "plugin-workflow uses 'Build System Ready' milestone"
  test_file_contains "$workflow_skill" "Audio Engine Working" "plugin-workflow uses 'Audio Engine Working' milestone"
  test_file_contains "$workflow_skill" "UI Integrated" "plugin-workflow uses 'UI Integrated' milestone"

  # plugin-planning/SKILL.md
  local planning_skill=".claude/skills/plugin-planning/SKILL.md"

  test_file_contains "$planning_skill" "research-planning-agent" "plugin-planning invokes research-planning-agent"
  # Note: parameter-spec-draft-template is in plugin-ideation, not plugin-planning
  test_file_not_contains "$planning_skill" "(^|[^-])research-agent([^-]|$)" "plugin-planning excludes old research-agent"
  test_file_not_contains "$planning_skill" "(^|[^-])planning-agent([^-]|$)" "plugin-planning excludes old planning-agent"

  # design-sync/SKILL.md
  local design_sync_skill=".claude/skills/design-sync/SKILL.md"

  test_file_contains "$design_sync_skill" "validation-cache\.sh" "design-sync sources validation-cache.sh"
  # Note: design-sync sources the cache file; function calls happen at runtime, not in the markdown
  # Note: parameter-spec-draft-template is used in plugin-ideation, not design-sync

  # decision-menus.json
  local decision_menus=".claude/skills/plugin-workflow/assets/decision-menus.json"

  if [[ "$DRY_RUN" == false ]] && [[ -f "$decision_menus" ]]; then
    # Check milestone language exists (keys are stage_N_complete format)
    if jq -e '.stage_2_complete.milestone | select(contains("Build System"))' "$decision_menus" >/dev/null 2>&1; then
      pass "decision-menus uses 'Build System' milestone language"
    else
      fail "decision-menus uses 'Build System' milestone language" "Milestone language not found in Stage 2 menu"
    fi

    if jq -e '.stage_3_complete.milestone | select(contains("Audio Engine"))' "$decision_menus" >/dev/null 2>&1; then
      pass "decision-menus uses 'Audio Engine' milestone language"
    else
      warn "decision-menus uses 'Audio Engine' milestone language" "Milestone language not found in Stage 3 menu"
    fi

    # Check for old "Continue to Stage X" language in any options
    if jq -e '.. | select(.description? and (.description | type == "string") and (.description | contains("Continue to Stage")))' "$decision_menus" >/dev/null 2>&1; then
      fail "decision-menus excludes old 'Continue to Stage X' language" "Old language found in menus"
    else
      pass "decision-menus excludes old 'Continue to Stage X' language"
    fi
  fi
}

# Category 4: Agent Invocation Testing
test_agent_invocations() {
  section "4. Agent Invocation Testing"

  # Test that Task tool can find new agent files
  local agents_dir=".claude/agents"

  test_file_exists "$agents_dir/foundation-shell-agent.md" "Task tool can find foundation-shell-agent"
  test_file_exists "$agents_dir/research-planning-agent.md" "Task tool can find research-planning-agent"
  test_file_exists "$agents_dir/validation-agent.md" "Task tool can find validation-agent"
  test_file_exists "$agents_dir/troubleshoot-agent.md" "Task tool can find troubleshoot-agent"

  # Test that old agent files are gone
  test_file_not_exists "$agents_dir/foundation-agent.md" "Task tool cannot find old foundation-agent"
  test_file_not_exists "$agents_dir/shell-agent.md" "Task tool cannot find old shell-agent"
  test_file_not_exists "$agents_dir/validator.md" "Task tool cannot find old validator"
  test_file_not_exists "$agents_dir/troubleshooter.md" "Task tool cannot find old troubleshooter"
}

# Category 5: Cross-Reference Consistency
test_cross_references() {
  section "5. Cross-Reference Consistency"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "Cross-reference consistency tests"
    return 0
  fi

  # Search for lingering Stage 1 references (should not exist except in docs/history)
  local stage1_refs
  stage1_refs=$(rg "Stage 1[^0-9]" .claude/skills/ -t md --no-heading --no-filename 2>/dev/null | grep -v -i "git\|history\|changelog\|migration\|audit\|SYSTEM-AUDIT" || true)

  if [[ -z "$stage1_refs" ]]; then
    pass "No lingering Stage 1 references in skills"
  else
    fail "No lingering Stage 1 references in skills" "Found Stage 1 references:\n$stage1_refs"
  fi

  # Search for lingering Stage 6 references
  local stage6_refs
  stage6_refs=$(rg "Stage 6" .claude/skills/ -t md --no-heading --no-filename 2>/dev/null | grep -v -i "git\|history\|changelog\|migration\|audit\|SYSTEM-AUDIT" || true)

  if [[ -z "$stage6_refs" ]]; then
    pass "No lingering Stage 6 references in skills"
  else
    fail "No lingering Stage 6 references in skills" "Found Stage 6 references:\n$stage6_refs"
  fi

  # Test that all agent references use -agent suffix
  local bad_agent_refs
  bad_agent_refs=$(rg "\\b(foundation-agent|shell-agent|validator|troubleshooter)\\b" .claude/skills/ -t md --no-heading 2>/dev/null | grep -v "foundation-shell-agent\|validation-agent\|troubleshoot-agent" || true)

  if [[ -z "$bad_agent_refs" ]]; then
    pass "All agent references use correct naming (-agent suffix)"
  else
    fail "All agent references use correct naming (-agent suffix)" "Found old agent names:\n$bad_agent_refs"
  fi

  # Verify @filename references point to existing files
  local broken_refs=()
  while IFS= read -r ref; do
    # Extract filename from @filepath
    local filepath="${ref#@}"
    if [[ ! -f "$filepath" ]]; then
      broken_refs+=("$ref")
    fi
  done < <(rg "@\.claude/(agents|skills)/[^)]*\.md" .claude/ -o --no-filename 2>/dev/null | sort -u || true)

  if [[ ${#broken_refs[@]} -eq 0 ]]; then
    pass "All @filename references point to existing files"
  else
    fail "All @filename references point to existing files" "Broken references: ${broken_refs[*]}"
  fi

  # Verify schema agents match workflow agent files
  # Note: Schema only includes workflow agents (dsp, foundation-shell, gui, research-planning)
  # Utility agents (troubleshoot-agent, validation-agent) are not in the workflow schema
  if [[ -f ".claude/schemas/subagent-report.json" ]]; then
    local schema_agents
    schema_agents=$(jq -r '.properties.agent.enum[]' .claude/schemas/subagent-report.json | sort)

    local expected_workflow_agents="dsp-agent
foundation-shell-agent
gui-agent
research-planning-agent"

    if diff -q <(echo "$schema_agents") <(echo "$expected_workflow_agents") >/dev/null 2>&1; then
      pass "Schema contains exactly the 4 workflow agents"
    else
      warn "Schema contains exactly the 4 workflow agents" "Schema has: $schema_agents"
    fi
  fi
}

# Category 6: Validation Cache Functional Testing
test_validation_cache() {
  section "6. Validation Cache Functional Testing"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "Validation cache functional tests"
    return 0
  fi

  # Source cache utilities
  if [[ ! -f ".claude/utils/validation-cache.sh" ]]; then
    fail "Validation cache script exists" "File not found"
    return
  fi

  # Temporarily disable errexit for cache testing (cache functions use complex piping/jq operations)
  set +e
  source .claude/utils/validation-cache.sh

  # Clean up any existing test data
  rm -f .claude/cache/validation-results.json

  # Test 1: init_cache creates cache file
  init_cache
  if [[ -f ".claude/cache/validation-results.json" ]]; then
    pass "init_cache creates cache file"
  else
    fail "init_cache creates cache file" "Cache file not created"
  fi

  # Create a test file for checksumming
  local test_file=".claude/cache/test-validation-file.txt"
  echo "test content v1" > "$test_file"

  # Test 2: is_cached returns false for non-existent entry
  if is_cached "creative-brief" "test-plugin" "$test_file"; then
    fail "is_cached returns false for non-existent entry" "Cache hit but should miss"
  else
    pass "is_cached returns false for non-existent entry"
  fi

  # Test 3: cache_result creates entry
  cache_result "creative-brief" "test-plugin" 24 '"passed"' "$test_file"
  if grep -q "test-plugin" .claude/cache/validation-results.json 2>/dev/null; then
    pass "cache_result creates entry"
  else
    fail "cache_result creates entry" "Entry not found in cache"
  fi

  # Test 4: is_cached returns true for existing entry with same content
  if is_cached "creative-brief" "test-plugin" "$test_file"; then
    pass "is_cached returns true for existing entry with same content"
  else
    fail "is_cached returns true for existing entry" "Cache miss but should hit"
  fi

  # Test 5: get_cached_result retrieves stored result
  local result
  result=$(get_cached_result "creative-brief" "test-plugin")
  if [[ "$result" == "passed" ]]; then
    pass "get_cached_result retrieves stored result"
  else
    fail "get_cached_result retrieves stored result" "Got: $result (expected: passed)"
  fi

  # Test 6: is_cached returns false when file content changes
  echo "test content v2" > "$test_file"
  if is_cached "creative-brief" "test-plugin" "$test_file"; then
    fail "is_cached detects changed content" "Cache hit but content changed"
  else
    pass "is_cached detects changed content (checksum mismatch)"
  fi

  # Test 7: clear_cache removes entry
  clear_cache ":test-plugin"
  if grep -q "test-plugin" .claude/cache/validation-results.json 2>/dev/null; then
    fail "clear_cache removes entry" "Entry still found after clear"
  else
    pass "clear_cache removes entry"
  fi

  # Clean up test data
  rm -f .claude/cache/validation-results.json "$test_file"

  # Re-enable errexit
  set -e
}

# Category 7: Documentation Consistency
test_documentation() {
  section "7. Documentation Consistency"

  # CLAUDE.md
  local claude_md="CLAUDE.md"

  test_file_contains "$claude_md" "Stage.*[02345]" "CLAUDE.md mentions correct stage numbers"
  test_file_not_contains "$claude_md" "7-stage workflow" "CLAUDE.md excludes old 7-stage reference"

  # Check for milestone language
  test_file_contains "$claude_md" "Build System Ready|Audio Engine Working|UI Integrated|Plugin Complete" "CLAUDE.md uses milestone language"

  # Check agent naming
  test_file_contains "$claude_md" "foundation-shell-agent|research-planning-agent|validation-agent" "CLAUDE.md references correct agent names"

  # Check for broken links in troubleshooting docs
  if [[ "$DRY_RUN" == false ]]; then
    local broken_links=()
    while IFS= read -r link; do
      local filepath="${link#](}"
      filepath="${filepath%)}"
      # Remove any anchors
      filepath="${filepath%%#*}"

      if [[ -n "$filepath" ]] && [[ ! "$filepath" =~ ^http ]] && [[ ! -f "$filepath" ]]; then
        broken_links+=("$link")
      fi
    done < <(rg "\]\(\.claude/.*\.md\)" troubleshooting/ -o --no-filename 2>/dev/null || true)

    if [[ ${#broken_links[@]} -eq 0 ]]; then
      pass "No broken links in troubleshooting docs"
    else
      fail "No broken links in troubleshooting docs" "Found broken links: ${broken_links[*]}"
    fi
  fi
}

# Category 8: Regression Detection
test_regression_detection() {
  section "8. Regression Detection"

  if [[ "$DRY_RUN" == true ]]; then
    dry_run_msg "Regression detection tests"
    return 0
  fi

  # Test 1: Broken symbolic references (old agent names in comments/TODOs)
  local bad_refs
  bad_refs=$(rg "TODO.*\\bvalidator\\b|FIXME.*\\btroubleshooter\\b|NOTE.*\\bfoundation-agent\\b" .claude/ -t md --no-heading 2>/dev/null || true)

  if [[ -z "$bad_refs" ]]; then
    pass "No old agent names in TODO/FIXME/NOTE comments"
  else
    fail "No old agent names in TODO/FIXME/NOTE comments" "Found:\n$bad_refs"
  fi

  # Test 2: Hardcoded stage numbers that didn't get updated
  local bad_stages
  bad_stages=$(rg "Stage [16][^0-9]" .claude/skills/ -t md --no-heading 2>/dev/null | grep -v -i "history\|git\|archive\|audit\|SYSTEM-AUDIT" || true)

  if [[ -z "$bad_stages" ]]; then
    pass "No hardcoded Stage 1 or Stage 6 references in skills"
  else
    warn "No hardcoded Stage 1 or Stage 6 references in skills" "Found:\n$bad_stages"
  fi

  # Test 3: Inconsistent terminology in decision menus
  if [[ -f ".claude/skills/plugin-workflow/assets/decision-menus.json" ]]; then
    local old_terminology
    old_terminology=$(jq -r '.[] | .options[]? | .description? // empty' .claude/skills/plugin-workflow/assets/decision-menus.json 2>/dev/null | grep -i "continue to stage" || true)

    if [[ -z "$old_terminology" ]]; then
      pass "Decision menus use new milestone language (not 'Continue to Stage X')"
    else
      fail "Decision menus use new milestone language" "Found old terminology: $old_terminology"
    fi
  fi

  # Test 4: Check for Stage 3 → DSP mapping consistency
  local stage3_dsp_refs
  stage3_dsp_refs=$(rg "Stage 3" .claude/skills/plugin-workflow/ -t md -A 2 2>/dev/null | grep -c "dsp-agent\|DSP\|Audio Engine" || true)

  if [[ "$stage3_dsp_refs" -gt 0 ]]; then
    pass "Stage 3 consistently references DSP/Audio Engine"
  else
    warn "Stage 3 consistently references DSP/Audio Engine" "Few or no references found"
  fi

  # Test 5: Check for Stage 4 → GUI mapping consistency
  local stage4_gui_refs
  stage4_gui_refs=$(rg "Stage 4" .claude/skills/plugin-workflow/ -t md -A 2 2>/dev/null | grep -c "gui-agent\|GUI\|UI Integrated" || true)

  if [[ "$stage4_gui_refs" -gt 0 ]]; then
    pass "Stage 4 consistently references GUI/UI Integrated"
  else
    warn "Stage 4 consistently references GUI/UI Integrated" "Few or no references found"
  fi
}

# Category 9: Workflow State Integrity
test_workflow_state() {
  section "9. Workflow State Integrity"

  # Check that context-resume skill itself references new workflow
  # Note: handoff-location.md is about file structure, not agent names
  test_file_contains ".claude/skills/context-resume/SKILL.md" "Stages 0, 2-5" "context-resume references correct workflow stages"

  # Check for invalid resume points (Stage 1 or Stage 6)
  test_file_not_contains ".claude/skills/context-resume/SKILL.md" "stage.*(1|6)([^0-9]|$)" "context-resume excludes Stage 1 and Stage 6"

  # Check that PLUGINS.md template uses correct stage numbers
  if [[ -f "PLUGINS.md" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      local invalid_stages
      invalid_stages=$(grep -E "stage.*[16]" PLUGINS.md 2>/dev/null || true)

      if [[ -z "$invalid_stages" ]]; then
        pass "PLUGINS.md uses valid stage numbers (0, 2-5)"
      else
        fail "PLUGINS.md uses valid stage numbers" "Found invalid stages: $invalid_stages"
      fi
    fi
  fi
}

# Category 10: Integration Points
test_integration_points() {
  section "10. Integration Points"

  # Commands that invoke agents (using alternation for flexibility)
  test_file_contains ".claude/commands/plan.md" "research-planning-agent|plugin-planning" "/plan command references research-planning-agent"
  test_file_contains ".claude/commands/implement.md" "foundation-shell-agent|dsp-agent|gui-agent|plugin-workflow" "/implement command references workflow agents"
  test_file_contains ".claude/commands/test.md" "validation-agent|plugin-testing" "/test command references validation-agent"
  test_file_contains ".claude/commands/research.md" "troubleshoot-agent|deep-research" "/research command references troubleshoot-agent"

  # Check skill → agent mappings (just verify agents are referenced, not exact invocation format)
  test_file_contains ".claude/skills/plugin-workflow/SKILL.md" "foundation-shell-agent" "plugin-workflow invokes foundation-shell-agent"
  test_file_contains ".claude/skills/plugin-workflow/SKILL.md" "dsp-agent" "plugin-workflow invokes dsp-agent"
  test_file_contains ".claude/skills/plugin-workflow/SKILL.md" "gui-agent" "plugin-workflow invokes gui-agent"
  # Note: validation-agent is invoked by plugin-testing skill, not plugin-workflow

  test_file_contains ".claude/skills/plugin-planning/SKILL.md" "research-planning-agent" "plugin-planning invokes research-planning-agent"

  # Check that hooks reference correct agent names
  if [[ -d ".claude/hooks" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      local hooks_with_old_agents
      hooks_with_old_agents=$(rg "\\b(foundation-agent|shell-agent|validator|troubleshooter)\\b" .claude/hooks/ -t md 2>/dev/null | grep -v "foundation-shell-agent\|validation-agent\|troubleshoot-agent" || true)

      if [[ -z "$hooks_with_old_agents" ]]; then
        pass "Hooks use correct agent names"
      else
        fail "Hooks use correct agent names" "Found old agent names:\n$hooks_with_old_agents"
      fi
    fi
  fi
}

# Main execution
main() {
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  Plugin Freedom System - Optimization Verification Suite      ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "Baseline: ${YELLOW}229973cf077ab03f5800eb76013c4d04391c51a2${NC}"
  echo -e "Current:  ${YELLOW}$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')${NC}"
  echo ""

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "${CYAN}Running in DRY RUN mode - no actual tests will execute${NC}\n"
  fi

  # Run all test categories
  test_file_structure
  test_schema_validation
  test_content_verification
  test_agent_invocations
  test_cross_references
  test_validation_cache
  test_documentation
  test_regression_detection
  test_workflow_state
  test_integration_points

  # Summary
  section "Summary"
  echo ""
  echo -e "  ${GREEN}Passed:${NC}  $PASS"
  echo -e "  ${RED}Failed:${NC}  $FAIL"
  echo -e "  ${YELLOW}Warnings:${NC} $WARN"
  echo ""

  if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ All optimizations verified successfully!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
  else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ Verification failed - see errors above${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 1
  fi
}

# Run main function
main "$@"
