---
name: honcho-memory-integration
description: Honcho persistent memory integration patterns for multi-context AI agent environments. Use when managing memory across multiple agents, projects, or sessions — structuring facts, cross-context retrieval, memory lifecycle management, conflict prevention, and agent-to-agent memory sharing.
version: 1.0.0
author: Hermes Agent
metadata:
  hermes:
    tags: [memory, honcho, multi-context, persistence, integration]
    related_skills: [2nd-brain, recursive-self-improvement, para-memory-files]
---

# Honcho Memory Integration

## Overview

Honcho (honcho.app) provides persistent memory with scoping by `app_id`, `user_id`, and `session_id`. 
Used as the active memory provider in this environment. Configuration at `~/.hermes/honcho.json`.

### Current Config
- **Host:** hermes
- **Workspace:** hermes
- **Recall mode:** hybrid (semantic + metadata)
- **Write frequency:** async
- **Observation:** user(me=True,others=True) ai(me=True,others=True)
- **Session key:** hermes-agent

## Core Concepts

### Scoping Hierarchy
1. **app_id** — isolates memory per project/application
2. **user_id** — isolates memory per user
3. **session_id** — isolates memory per conversation session

Use distinct `app_id` per project. Tag memories with `{project: "x", context: "planning", status: "active"}`.

### Memory Lifecycle
```
Create → Tag → Retrieve → Use → Update/Supersede → Archive
```

| Phase | Action |
|-------|--------|
| **Project start** | Save mandate, PBS, tolerances as `context:persistent` memories |
| **During execution** | Log exceptions, quality register updates, progress snapshots |
| **Stage boundary** | Archive stage report, update baseline memory |
| **Project close** | Final debrief → `status:archived` for future retrieval |

## Multi-Context Strategies

### Per-Project Scoping
- Use distinct `app_id` per project
- Tag: `{project: "name", context: "planning", status: "active"}`
- Query with project-scoped metadata to prevent cross-project leakage

### Cross-Session Continuity
- Create `context:global` session per user for recurring patterns
- Copy high-value session memories into it
- Prune stale entries via TTL

### Agent-to-Agent Sharing
- Honcho shares across all agents connected to the same workspace
- Use `aiPeer` field to designate AI agent identity
- Memory observations flow directionally based on `observationMode: directional`

## Conflict Prevention

| Rule | Implementation |
|------|---------------|
| **Append-first** | Always append new observations; use `memory_id` for explicit updates |
| **Never blind overwrite** | Honcho does NOT auto-merge — explicit update required |
| **Deduplication** | Semantic similarity > 0.85 triggers merge/skip |
| **Cross-session tags** | Tag with `context:global` for persistence beyond session |

## Retrieval Tiers

| Tier | Strategy | Injection |
|------|----------|-----------|
| **High** | Metadata match + semantic similarity | System prompt |
| **Medium** | Semantic only | Tool context |
| **Low** | Fallback | On-demand fetch |

## Best Practices

1. **Tag everything** — metadata tags enable precise filtering. Every memory should have at least `context` and `status` tags.
2. **Never raw-log** — curate before saving. Summarize → deduplicate → tag → upsert.
3. **Scope queries tightly** — use metadata filters, not just semantic search. Prevents noisy retrievals.
4. **Use hybrid recall** — combines semantic similarity with exact metadata matching for best precision.
5. **Archival discipline** — mark completed project memories as `status:archived` rather than deleting.
6. **Async writes are safe** — Honcho's async write mode handles queuing and retry automatically.
7. **Check memory count** — regular monitoring of fact count per user/AI peer to detect accumulation issues.

## Memory Consolidation Cycles

Like human sleep, agents need periodic offline memory consolidation.

### During Active Sessions
- Write episodic memories: raw task traces, specific learnings, session facts
- Tag with `session_id`, `timestamp`, `context` for temporal tracking
- NEVER raw-log — always curate: summarize → deduplicate → tag → upsert

### During Consolidation (off-peak, via cron)
1. **Compress** episodic → semantic: extract general principles from specific instances
2. **Generalize** across domains: transfer learning between projects (cross-domain pattern detection)
   - Error handling patterns from Python → JavaScript → shell scripting
   - Testing strategies from backend → frontend → infrastructure
   - Architecture patterns from one domain → structurally similar domains
3. **Deduplicate**: find semantically similar memories (similarity > 0.85), merge or supersede
4. **Resolve contradictions**: identify conflicting facts, flag for resolution
5. **Enforce budgets**: cap memory count per retrieval tier (High: ≤50, Medium: ≤200, Low: ≤500)
6. **Cross-domain transfer**: Abstract patterns to their core structure before applying to new domains

### Utility Score Decay
```
score = usage_frequency × success_rate × recency_factor
```
- Purge memories with score < 0.2 during consolidation
- Re-score all memories monthly (not per session — saves compute)
- Track decay trends to identify degrading knowledge areas
- NEVER delete — always mark `status: superseded` with `superseded_by` link

## 2026 Research Updates

### Agent-as-Curator Pattern
Honcho is a storage/retrieval substrate. The **agent** must implement:
- Filtering before writes (don't save raw tool outputs, save derived insights)
- Intelligent tagging (always include at minimum: `context` + `status`)
- Lifecycle management (episodic → semantic consolidation happens via cron, not in-session)
- Conflict prevention (Honcho does NOT auto-merge — explicit `memory_id` update required)

### Multi-Context Strategy Refinement
For environments with multiple agents, profiles, and sessions:
1. **Per-project scoping**: Distinct `app_id` + `project:name` metadata tag. Enforce project-scoped queries.
2. **Cross-session continuity**: Maintain `context:global` session per user. Periodically copy high-value session memories.
3. **Agent-to-agent sharing**: Honcho shares across all agents in same workspace. Memory flows directionally based on `observationMode: directional`.
4. **Memory count monitoring**: Regularly check fact count per user/AI peer to detect accumulation issues.

### Consolidation Frequency
- **Active sessions**: Write episodic (high frequency, low consolidation)
- **Per-day off-peak**: Compress to semantic, deduplicate, decay scoring
- **Monthly**: Full audit — prune, re-score, cross-domain generalization
