---
name: brain-audit-cycle
description: Systematic brain housekeeping and self-improvement audit — memory review, skill freshness audit across dual-layer structure (umbrella + sub-skills), research-to-skill integration, hardcoded path detection, service health verification, brain archival and sync. Use for cron housekeeping tasks or periodic maintenance.
version: 1.1.0
author: Hermes Agent
metadata:
  hermes:
    tags: [maintenance, audit, skills, brain, self-improvement, cron]
    related_skills: [2nd-brain, recursive-self-improvement, brain-sync, honcho-memory-integration]
---

# Brain Audit Cycle — Housekeeping & Self-Improvement

## Overview

Systematic audit of the Hermes brain ecosystem: skills freshness, memory quality, service health, and research integration. Run as a cron job or on-demand maintenance.

## Phase 1: Discovery

```bash
# Find the hermes-agent workspace
find /home -maxdepth 4 -name "hermes-agent" -type d 2>/dev/null

# Check all skills directories (user profile + repo copy + brain)
ls ~/.hermes/skills/
ls ~/.hermes/hermes-agent/skills/ 2>/dev/null
ls ~/brain/skills/ 2>/dev/null

# Check memory files
cat ~/.hermes/SOUL.md
cat ~/.hermes/auth.json | head -20
```

## Phase 2: Skill Freshness Audit

**CRITICAL: Dual-layer structure awareness.** Skills exist as TWO types:
1. **Leaf skills** — have `SKILL.md` in their directory (self-contained)
2. **Umbrella categories** — NO root `SKILL.md`, but contain sub-directories with `SKILL.md` each

```python
# Script to audit skill health
import os
skills_dir = os.path.expanduser("~/.hermes/skills")
missing_md = []
for name in os.listdir(skills_dir):
    skill_path = os.path.join(skills_dir, name)
    if os.path.isdir(skill_path) and not name.startswith('.'):
        has_md = os.path.exists(os.path.join(skill_path, "SKILL.md"))
        has_subskills = any(
            os.path.exists(os.path.join(skill_path, s, "SKILL.md"))
            for s in os.listdir(skill_path)
            if os.path.isdir(os.path.join(skill_path, s))
        )
        if not has_md and not has_subskills:
            missing_md.append(name)
        # Umbrella OK if has_subskills even without root SKILL.md

# Check for skills without SKILL.md AND no sub-skills — these are orphaned
print(f"Orphaned (likely): {missing_md}")
```

**What to fix in each skill:**
- Remove or replace hardcoded user paths (e.g. `/home/unclehowell` → `${BRAIN_ROOT}` or `~`)
- Update version numbers when making changes
- Fix broken file references, URLs, or command examples
- Ensure memory tool commands are only used where available (not in cron contexts)

## Phase 3: Research Integration

```bash
# Check for research findings to integrate
ls ~/research-rsi/ 2>/dev/null
cat ~/research-rsi/gaps_and_recommendations.md 2>/dev/null
```

**Integration pattern:**
1. Read research gaps/recommendations
2. Compare against current skill content
3. Use `skill_manage(action='patch')` to add missing patterns
4. Update version number and description

## Phase 4: Service Health Check

```bash
echo "=== SERVICE STATUS ==="
for svc in nginx netdata jellyfin; do
  echo "$svc: $(systemctl is-active $svc 2>/dev/null || echo unknown)"
done
echo "Hermes Gateway: $(pgrep -c hermes || echo 0) processes"
echo "Auth Server: $(pgrep -f auth-server || echo 0) processes"
echo "GUI: $(systemctl is-active gui 2>/dev/null || echo unknown)"
echo "Watch-Sync: $(pgrep -c watch-sync.sh || echo 0) processes"

echo "=== DISK ==="
df -h /
echo "Checkpoints: $(du -sh ~/.hermes/checkpoints/ 2>/dev/null)"
```

## Phase 5: Temp Cleanup

```bash
# Find user-owned stale files in /tmp
find /tmp -maxdepth 1 -type f -user $USER -mtime +7 2>/dev/null

# Remove orphaned lock files (age >24h)
find /tmp -name "*.lock" -user $USER -mtime +1 -delete 2>/dev/null
```

## Phase 6: Brain Archive + Sync

**NOTE:** The memory tool is DISABLED in cron context. ALWAYS use brain files for archival.

```bash
# Archive learnings (MUST use brain files in cron context)
mkdir -p ~/brain/memory/archive/learned/$(date +%F)/
# Write learning file...

# Sync to GitHub
bash ~/brain/scripts/sync.sh
```

## Phase 7: Memory Consolidation (New - Cron-Optimized)

The cron audit cycle includes cross-domain pattern detection and utility scoring:

1. **Cross-domain transfer**: Identify patterns applicable to unrelated domains
   - Error handling patterns from Python → JavaScript
   - Testing strategies from backend → frontend
   - Architecture patterns reused in similar projects

2. **Skill pruning review**:
   - Check for unused skills (>30 days) → archive candidate
   - Score each skill: success_rate × usage_frequency × recency
   - Flag skills scoring <0.2 for deletion review

3. **Memory decay analysis**:
   - Count facts per category from session_search results
   - Topics with 0 hits in 30 days → candidate for archival
   - High-utility facts → tag for permanent retention

## Key Pitfalls

- **Memory tool ALWAYS unavailable in cron**: The `memory` tool returns error "Memory is not available. It may be disabled in config or this environment." CONFIRMED. Use brain files (`~/brain/memory/`) for archival and session_search for recall instead.
- **No venv in some environments**: Check if `venv/` exists before `source venv/bin/activate`. Fall back to system `python3`.
- **Brain symlink can resolve differently**: Always use `~/brain/` or `${BRAIN_ROOT}`, never hardcoded `/home/USERNAME/brain/`.
- **Umbrella skills without root SKILL.md are NORMAL**: Don't try to "fix" them — they have nested sub-skills.
- **Honcho config in multiple places**: Check both `~/.hermes/config.yaml` and `~/.hermes/honcho.json`.
- **Checkpoints directory grows unbounded**: Monitor `~/.hermes/checkpoints/` — can consume GBs over time.
- **Parallel research delegation works well**: Use `delegate_task` with 3 parallel web research tasks for PRINCE2, recursive self-improvement, and Honcho patterns. Each subagent produces structured output that feeds skill updates.
- **Hermes config lives in repo directory**: Check `~/.hermes/hermes-agent/config.yaml` for tool settings, not just the root `~/.hermes/config.yaml`.
- **Home directory has agent subdirectories**: `hermes_cmd_agent1-4` directories indicate multi-agent setup. Check each profile's config separately if auditing all.

## Parallel Research Pattern (New - 2026-04-07)

For comprehensive audits, use this delegation pattern to research all three domains simultaneously:

```python
delegate_task(
    tasks=[
        {"goal": "Research PRINCE2 methodology - 7 principles, themes, processes", "toolsets": ["web"]},
        {"goal": "Research recursive self-improvement best practices for AI agents", "toolsets": ["web"]},
        {"goal": "Research Honcho persistent memory integration patterns", "toolsets": ["web"]}
    ]
)
```

All 3 run concurrently (~90s total wall time), producing structured findings ready for skill patch integration.