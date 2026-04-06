---
name: project-delivery
description: End-to-end project delivery methodology combining PRINCE2 governance, AI agent workflows, recursive self-improvement, and Honcho memory. Use for any multi-step project requiring structured delivery with quality gates, stage-gate progression, exception management, and learning capture. Supersedes standalone PRINCE2 for day-to-day work.
version: 1.0.0
author: Hermes Agent
metadata:
  hermes:
    tags: [project-management, delivery, prInce2, self-improvement, quality, stages]
    related_skills: [prince2, recursive-self-improvement, writing-plans, subagent-driven-development, requesting-code-review]
---

# Project Delivery Methodology

## Overview

Merges PRINCE2 governance with AI agent execution patterns into a single delivery framework. 
Follow this for all multi-step tasks (>3 tool calls).

## The Delivery Pipeline

```
MANDATE → BRIEF → PLAN → EXECUTE → CHECKPOINT → DEBRIEF
                ↑          ↓
         (Quality Gates)  (Self-Improve)
```

### Phase 1: MANDATE (Requirements Capture)
- What exactly are we building? (product, not activities)
- Success criteria: measurable, testable
- Constraints: time, budget, technical
- Stakeholders: who decides, who reviews

### Phase 2: BRIEF (Solution Design — **Present BEFORE coding**)
- Product Breakdown Structure (PBS): System → Module → Component → Tests + Docs
- Work packages with clear deliverables
- Risk assessment with mitigations
- Quality criteria per deliverable
- Estimated timeline with tolerance margins (±5% time, ±10% cost)
- **Get explicit approval before proceeding**

### Phase 3: PLAN (Hierarchical Task Graph)
- Decompose work packages into tasks with dependencies
- Assign to agent or subagent
- Set quality gates: lint, type-check, test coverage, security scan
- Define tolerance thresholds per stage

### Phase 4: EXECUTE (Iterative Delivery)
- Bite-sized increments per work package
- Mini cycle: implement → test → review → commit
- Quality gates at stage boundaries
- Real-time status tracking: 🟢 on track / 🟡 risk / 🔴 blocked

### Phase 5: CHECKPOINT (Stage Gate)
- Validate all deliverables against product descriptions
- Run automated gate checks
- Update progress metrics
- Generate highlight report:
  - What's done / planned next / risks / tolerance status

### Phase 6: DEBRIEF (Close & Learn)
- Final status: planned vs actual
- What went well / what could be improved
- Archive learnings to brain and session memory
- Update skills with new patterns
- Capture lessons for recursive self-improvement

## Quality Gates (Mandatory)

| Gate | Criteria |
|------|----------|
| **Entry** | Requirements clear, PBS defined, tolerances set |
| **Code** | Tests pass, lint/type-clean, no security warnings, coverage ≥ 80% |
| **Review** | Spec compliance + code quality review approved |
| **Exit** | Docs updated, lessons archived, handover ready |

## Exception Management

When tolerances are breached (time >±5%, quality <threshold, scope beyond MoSCoW):
1. **Pause** — stop current work
2. **Assess** — generate exception report with cause, impact, recovery options
3. **Escalate** — present 3 options (revise plan / reduce scope / abort)
4. **Wait** — do NOT proceed until direction received
5. **Resume** — execute approved direction, log outcome

## Self-Improvement Loop

After every task:
1. **Archive** — save what worked, what failed, why
2. **Update Skills** — promote successful patterns to skills
3. **Score Memories** — bump access_count on used facts
4. **Check Convergence** — are we getting faster/fewer iterations across dimensions?

Track across ≥2 orthogonal dimensions: pass rate, token cost, iteration count, regression rate.

## Usage

1. Start at MANDATE for any multi-step task
2. Build PBS before coding
3. Present BRIEF for approval
4. Execute through quality gates
5. Close with DEBRIEF
6. Load `prince2` skill for detailed governance reference
7. Load `recursive-self-improvement` for meta-learning patterns
