---
name: prince2
description: PRINCE2 methodology — mandatory framework for all software projects and delegated tasks. Covers 7 principles, 7 themes, 7 processes mapped to AI agent workflows with stage-gate delivery, product-based planning, exception management, and quality gates.
version: 2.0.0
author: Hermes Agent (enhanced with PRINCE2 official framework research)
metadata:
  hermes:
    tags: [project-management, governance, planning, quality, risk, delivery]
    related_skills: [writing-plans, subagent-driven-development, requesting-code-review, plan]
---

# PRINCE2 — Project Management for AI Agents

## Overview

PRINCE2 (PRojects IN Controlled Environments) is a process-driven, product-focused project management framework. This skill maps its 7 principles, 7 themes, and 7 processes to AI coding agent workflows for structured, high-quality delivery.

**This skill is MANDATORY for all delegated work and multi-step projects.**

---

## The 7 Principles (Mandatory Foundations)

No project proceeds unless ALL 7 principles are satisfied:

| # | Principle | AI Agent Implementation |
|---|-----------|------------------------|
| 1 | **Continued Business Justification** | Before starting, validate: acceptance criteria are clear, success metrics defined, ROI viable. Halt if scope drifts from value. |
| 2 | **Learn from Experience** | Consult knowledge base (brain files, session history, past PRs) before coding. Append new learnings after completion. |
| 3 | **Defined Roles & Responsibilities** | Operate within permission scopes. Clear escalation: agent implements/reviews → human approves/merges. Never self-approve production changes. |
| 4 | **Manage by Stages** | Work partitioned into phases (Design → Implement → Test → Deploy). Each stage has entry/exit criteria and a gate check. |
| 5 | **Manage by Exception** | Define tolerances per stage (time, complexity, test coverage, security score). Breaches = automatic pause + escalation. |
| 6 | **Focus on Products** | Start with Product Breakdown Structure (PBS). Derive tasks from tangible deliverables (APIs, modules, tests, docs), not activity lists. |
| 7 | **Tailor to Environment** | Scale rigor to project size: lightweight for POCs, strict compliance for production agents, CI/CD, and critical services. |

---

## The 7 Themes (Continuously Managed)

| Theme | What It Means | AI Agent Practice |
|-------|--------------|-------------------|
| **Business Case** | Why are we doing this? | Tag tasks with value metrics. De-scope low-ROI work. Track feature adoption post-deploy. |
| **Organization** | Who does what? | Use role templates (Architect, Implementer, Reviewer, QA). RACI matrix for AI vs human decisions. |
| **Quality** | What does "good" look like? | Codify quality gates: lint, type-check, test coverage, security scan. Self-validate before submission. |
| **Plans** | How, when, by whom? | Generate hierarchical task graphs with dependencies, time budgets, and milestones. Update based on actual velocity. |
| **Risk** | What could go wrong? | Pre-scan: dependency conflicts, breaking changes, tech debt. Maintain risk register. Auto-mitigate or escalate. |
| **Change** | How do we handle deviations? | Formal PR/MR workflows with impact analysis, migration scripts, rollback plans. No scope creep. |
| **Progress** | Where are we vs. plan? | Track: planned vs actual, test pass rate, code churn, defect density. Alert on tolerance breaches. |

---

## The 7 Processes (Chronological Flow)

| Process | Phase | AI Agent Action |
|---------|-------|----------------|
| 1. **Starting Up** (SU) | Pre-project | Context initialization. Verify repo access, env configs, ticket alignment. Draft PBS. Set stage tolerances. |
| 2. **Initiating** (IP) | Project setup | Generate initiation doc: architecture brief, quality/risk/change strategies, baseline plan, approval gates. |
| 3. **Directing** (DP) | Governance | Submit stage-end reports, exception requests, change proposals. Await authorization before proceeding. |
| 4. **Controlling a Stage** (CS) | Execution | Assign work packages. Track progress. Log issues. Manage tolerances. Trigger exception workflows on breach. |
| 5. **Managing Delivery** (MP) | Core dev loop | Implement per quality criteria. Run unit/integration tests. Package artifacts. Submit for review. |
| 6. **Stage Boundary** (SB) | Between phases | Validate deliverables. Update plans. Capture lessons learned. Draft next stage plan for approval. |
| 7. **Closing** (CP) | Project end | Final audit. Generate documentation. Compile post-project review. Deactivate ephemeral resources/branches. |

---

## The 5-Phase Delivery Framework

### PHASE 1: MANDATE
**Purpose:** Capture exact requirements before any work begins.

Required input:
- Exact description of what to achieve
- Measurable success criteria
- Any constraints (budget, timeline, technical)

### PHASE 2: BRIEF
**Purpose:** Present proposed solution for approval BEFORE work begins.

Deliverable:
- Product Breakdown Structure (PBS) — what gets built
- Work Packages — groupings of implementation tasks
- Risk assessment with mitigations
- Quality criteria and gate checks
- Estimated timeline with tolerance margins

**⚠️ User MUST approve before work starts.**

### PHASE 3: PLAN
**Purpose:** Execute with structured progress tracking.

- Progress tracked in bite-sized increments
- Each work package has its own mini cycle: implement → test → review
- Quality gates at stage boundaries
- Real-time status tracking with color indicators

### PHASE 4: HIGHLIGHT REPORTS
**Purpose:** Periodic structured updates for longer tasks.

Include at each checkpoint:
- What's been done since last report
- What's planned next
- Any risks or issues discovered
- Tolerance status (within / approaching / breached)

### PHASE 5: DEBRIEF
**Purpose:** Document lessons learned and final status.

- Final status: planned vs actual
- What went well / what could be improved
- Recommendations for future similar tasks
- Archive learnings to brain

---

## Visual Status Format

```
┌─────────────────────────────────────────────────────────────────────────┐
│  PROJECT: [Project Name]                              Status: 🟢 Active │
├─────────────────────────────────────────────────────────────────────────┤
│  MANDATE: [Brief description of what we want to achieve]               │
├─────────────────────────────────────────────────────────────────────────┤
│  Work Package     │ 1 (11%) │ 2 (22%) │ 3 (33%) │ 4 (44%) │ 5 (55%)    │
│  ─────────────────┼─────────┼─────────┼─────────┼─────────┼─────────── │
│  Status           │   🟢    │   🟡    │   ⚪    │   ⚪    │   ⚪       │
│  Task             │ Complete│ In Prog │  Pending│  Pending│  Pending  │
└─────────────────────────────────────────────────────────────────────────┘
```

### Color Schema
| Icon | Meaning |
|------|---------|
| 🟢 | Complete |
| 🟡 | In Progress |
| 🔴 | Blocked — needs help |
| ⚪ | Pending |
| 🟣 | On Hold |

### Project Status Icons
- 🟢 Active — Work ongoing
- 🟡 On Hold — Waiting on user/dependency
- 🔴 Blocked — Need intervention
- ✅ Complete — Finished
- ⚪ Not Started

---

## Exception Management

When tolerances are breached, follow this protocol:

1. **Detect** — Identify which tolerance was breached (time, quality, scope, risk)
2. **Pause** — Stop work on the current task. Do NOT proceed with work that violates tolerances.
3. **Assess** — Document the breach: what happened, root cause, impact on downstream work
4. **Escalate** — Present exception report with options:
   - Option A: Revised plan with new tolerances
   - Option B: Scope reduction to meet original tolerances  
   - Option C: Abort and reassess feasibility
5. **Wait** — Do NOT proceed until direction is received
6. **Resume** — Execute the approved direction and log the outcome

---

## Quality Management Approach

### Quality Gates (Mandatory)
Before advancing to the next stage, verify:

| Gate | Criteria |
|------|----------|
| **Entry Gate** | Requirements clear, PBS defined, tolerances set, acceptance criteria documented |
| **Code Gate** | All tests pass, lint/type-clean, no security warnings, coverage meets threshold |
| **Review Gate** | Spec compliance check passed, code quality review approved |
| **Exit Gate** | Documentation updated, lessons archived, handover packages ready |

### Product Descriptions
Every deliverable must have a clear description:
- **Purpose** — What this product does
- **Composition** — What it's made of (files, interfaces)
- **Derivation** — Where it comes from (inputs, dependencies)
- **Format** — How it's structured
- **Quality Criteria** — How we know it's correct
- **Quality Method** — How we verify (test, review, inspection)

---

## Usage

When receiving a new task:
1. Check if project context exists (mandate, brief, plan). If not, start at MANDATE.
2. Build the PBS before coding — know WHAT you're building before HOW.
3. Present the BRIEF for approval — get explicit go-ahead.
4. Execute with structured progress tracking and quality gates.
5. Deliver a DEBRIEF — archive learnings to brain and session memory.

---

## Anti-Patterns (Avoid These)

- ❌ Coding before understanding the product (violates Focus on Products)
- ❌ Changing scope without approval (violates Change Control)
- ❌ Proceeding after tolerance breach (violates Manage by Exception)
- ❌ Skipping quality gates to "move fast" (violates Quality Management)
- ❌ Not documenting how things went (violates Learn from Experience)
- ❌ Self-approving production changes (violates Defined Roles)
