---
name: project-delivery
description: End-to-end project delivery methodology combining PRINCE2 governance, AI agent workflows, recursive self-improvement, and Honcho memory. Use for any multi-step project requiring structured delivery with quality gates, stage-gate progression, exception management, and learning capture. Supersedes standalone PRINCE2 for day-to-day work.
version: 1.1.0
author: Hermes Agent (enhanced with PRINCE2 7th Edition updates, Benefits Realization Management, AI-optimized delivery patterns)
metadata:
  hermes:
    tags: [project-management, delivery, prInce2, self-improvement, quality, stages]
    related_skills: [prince2, recursive-self-improvement, writing-plans, subagent-driven-development, requesting-code-review]
---

# Project Delivery Methodology

## Overview

Merges PRINCE2 governance with AI agent execution patterns into a single delivery framework. 
Follow this for all multi-step tasks (>3 tool calls).

## The Delivery Pipeline (PRINCE2 7th Edition + AI Agent Workflow)

```
MANDATE → BRIEF → PLAN → EXECUTE → CHECKPOINT → DEBRIEF
                ↑          ↓                    ↓
         (Quality Gates)  (Self-Improve)    (Benefits Review)
```

### Phase 1: MANDATE (Starting Up — SU)
- What exactly are we building? (product, not activities — Focus on Products principle)
- Success criteria: measurable, testable
- Constraints: time, budget, technical
- Stakeholders: who decides, who reviews (Defined Roles & Responsibilities)
- Validate business justification (Continued Business Justification principle)
- Draft initial Product Breakdown Structure (PBS)

### Phase 2: BRIEF (Initiating — IP) — **Present BEFORE coding**
- Product Breakdown Structure: System → Module → Component → Tests + Docs
- Work packages with clear deliverables
- Risk assessment with mitigations (Risk theme)
- Quality criteria per deliverable (Quality theme)
- Estimated timeline with tolerance margins (±5% time, ±10% cost)
- Define tolerances for quality, scope (MoSCoW), risk exposure
- **Get explicit approval before proceeding** (Directing process)

### Phase 3: PLAN (Stage Planning)
- Decompose work packages into tasks with dependencies
- Assign to agent or subagent (subagent-driven-development skill)
- Set quality gates: lint, type-check, test coverage ≥80%, security scan
- Define tolerance thresholds per stage
- Generate hierarchical task graph with milestones

### Phase 4: EXECUTE (Controlling Stage + Managing Delivery — CS/MP)
- Bite-sized increments per work package
- Mini cycle: implement → test → review → commit (TDD cycle)
- Quality gates at stage boundaries
- Real-time status tracking: 🟢 on track / 🟡 approaching tolerance / 🔴 breached
- Monitor tolerances continuously (Manage by Exception principle)
- Multi-path exploration for complex problems: 3-5 candidates, score, merge best
- Log work packages, track progress, update quality register

### Phase 5: CHECKPOINT (Stage Boundary — SB)
- Validate all deliverables against product descriptions
- Run automated gate checks (test coverage ≥80%, zero P0/P1 defects, clean lint)
- Update progress metrics and business case
- Update risk register with current exposure
- Generate highlight report:
  - What's done / planned next / risks / tolerance status
  - Benefits status: 🟢 on track / 🟡 partial / 🔴 missed

### Phase 6: DEBRIEF (Closing — CP) + Benefits Realization
- Final status: planned vs actual across all dimensions
- Validate all quality register entries complete
- Benefits realization review: compare baseline vs actual KPIs
- What went well / what could be improved
- Archive learnings to brain and session memory
- Update skills with new patterns (recursive-self-improvement skill)
- Generate post-project review document
- Schedule post-deployment benefits tracking (if applicable)

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
