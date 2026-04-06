---
name: recursive-self-improvement
description: Patterns for compounding self-improvement in AI coding agents. Covers multi-path exploration loops, three-tier memory with decay, programmatic prompt optimization, skill promotion pipeline, and safe self-modification through sandboxed validation cycles.
version: 2.1.0
author: Hermes Agent (enhanced with 2024-2026 research, Honcho memory integration, Honcho multi-context patterns)
metadata:
  hermes:
    tags: [self-improvement, meta-cognition, optimization, learning, feedback-loops]
    related_skills: [2nd-brain, brain-sync, systematic-debugging, subagent-driven-development]
---

# Recursive Self-Improvement for AI Agents

## Core Principle

Compounding improvement occurs when gains in one subsystem unlock safer, more aggressive improvements in others. Build **closed-loop validation** and **permanent anchors** that make the agent progressively better with every task.

**Production pattern:** Constrained, metric-gated evolution with versioned memory and automated evaluation. NOT unconstrained self-rewriting.

---

## The Improvement Flywheel

```
  Tests → Safety → Refactoring → Better Tests → More Safety → ...
    ↑                                              ↓
  Prompts ← Meta-Learning ← Evaluation ← Knowledge
```

Each stage feeds the next:
1. **Tests create safety** — Strong test suites enable bolder self-modifications
2. **Knowledge improves prompts** — Documented fixes reduce repeat errors
3. **Evaluation enables meta-learning** — Reliable self-assessment trains better strategies
4. **Prompt optimization saves compute** — Leaner contexts allow more feedback cycles
5. **More cycles = faster improvement**

---

## Pattern 1: Multi-Path Feedback Loops (v3 — 2026 Update)

### The TDD-Driven Loop
Every task should follow this cycle:
1. **Generate** — Produce output (code, plan, analysis)
2. **Execute** — Run it in a sandboxed environment
3. **Evaluate** — Measure against objective criteria (tests pass? lint clean? matches spec?)
4. **Refine** — If it fails, parse errors into structured failure signatures, NOT raw dumps
5. **Archive** — Save the successful pattern for future reuse

**Speed matters:** < 10s for unit-level loops, < 2m for integration loops.

### Modular Critic-Actor Separation (2024-2025 research)
Modern agents use **separate modules** for execution parsing, error classification, and patch generation — NOT monolithic self-refine prompts. This reduces thrashing and improves diagnostic accuracy.

### Multi-Path Exploration
For complex problems, use **parallel candidate generation**:
- Generate 3-5 candidate solutions via delegate_task
- Score via automated judges (linters, test suites, complexity metrics)
- Merge strongest traits from each candidate
- Avoid sequential single-path loops which plateau quickly

### Adaptive Stopping Criteria
Hard iteration caps waste compute. Use confidence thresholds:
- Stop when Δ(pass_rate) < 2% over 2 iterations
- OR when resource/cost budget is exhausted
- Cap recursion depth at 3-5 self-mod cycles per session

### Memory Compaction (2024-2025 best practice)
Instead of storing raw few-shot examples, use **memory compaction pipelines**: an LLM summarizes past trajectories into deterministic rules, replacing raw examples to save context window and improve retrieval precision.

---

## Pattern 2: Three-Tier Memory with Decay

### Tier Structure
| Tier | What | TTL | How |
|------|------|-----|-----|
| **Episodic** | Recent task traces, tool calls | 24-72h | Hermes memory tool, session history |
| **Semantic** | Conceptual mappings, API behaviors, patterns | 30d+ | Brain files, skills |
| **Procedural** | Validated workflows, skills | Permanent (versioned) | Skill registry |

### Memory Decay Strategy
Utility score per memory: `score = usage_frequency × success_rate × recency_factor`

- Purge memories with score < 0.2
- Run weekly summarization: convert raw traces into compact principles
- Enforce strict token budgets per retrieval tier
- **Never delete facts** — mark `status: superseded` with `superseded_by` link

### What to Store
- Verified code patterns and tool invocation traces
- Failure signatures and root cause analyses
- Environment facts and API quirks
- Task-type → strategy mappings
- Successful prompt templates

---

## Pattern 3: Skill Evolution Pipeline

### The Promotion Pipeline
```
Trace → Abstract → Template → Validate → Version
```

### When to Create a New Skill
- Pattern achieves ≥85% success across ≥3 distinct tasks
- OR reduces token/latency cost by >20%
- OR overcomes a non-trivial error through investigation

### When to Update a Skill
- Used and found missing steps or incorrect commands
- Hit issues not covered by the "Pitfalls" section
- Environment changed (files moved, APIs updated)
- New best practice discovered that contradicts current guidance

### Skill Evolution Checklist
- [ ] Extract reusable pattern from successful trajectory
- [ ] Include exact commands, file paths, and output formats
- [ ] Add "Pitfalls" section with known gotchas
- [ ] Include verification steps
- [ ] Set version number
- [ ] Link to related skills

---

## Pattern 4: Programmatic Prompt Optimization

### Versioned Prompt Registry
- Track which prompting strategies work best per task type
- Use diff tracking — record what changed and why
- Avoid prompt bloat > 80% of context window; offload examples to external memory

### Strategy Tracking
| Strategy | Best For | Notes |
|----------|----------|-------|
| Direct instruction | Simple, well-defined tasks | Lowest token cost |
| Step-by-step with stage gates | Complex feature implementation | Prevents scope creep |
| Few-shot with retrieval | Domain-specific tasks | Higher quality, more tokens |
| Role-playing | Creative/generative tasks | Variable effectiveness |

### Self-Optimizing Meta-Prompts
After each failure cluster:
1. Auto-generate updated few-shot examples or constraint clauses
2. Test against next similar task
3. Promote winners based on empirical pass rates

---

## Pattern 5: Test-First Safety

The most important anchor for self-improvement:

```
Write tests BEFORE implementing → Tests become permanent guardrails → 
Can refactor aggressively → Tests catch regressions → More confidence → 
Bolder improvements → Better code → Cycle repeats
```

**Every improvement to the agent's own code, scripts, or configs must have tests first.**

---

## Pattern 6: Safety and Guardrails

### Strict Execution Boundaries
| Guardrail | Implementation |
|-----------|---------------|
| **Sandboxed execution** | Use `execute_code` and `terminal` with isolated contexts |
| **Pre-commit gates** | Static analysis, type checking, linting, security scans before any self-authored code |
| **Diff validation** | Review changes before applying. Never skip review for self-modifications |
| **Version control** | Git commit before major changes. Can revert if something breaks |
| **Human gates** | Production changes require approval. Agent handles dev/test autonomously |
| **Circuit breakers** | Auto-revert if post-modification regression > 5% |
| **Differential updates** | Apply patches, not full rewrites. Require improvement in ≥2 metrics |
| **No reward hacking** | Don't delete tests to pass. Don't skip quality gates. Enforce coverage floors |
| **Whitelist tools** | Cap which tools each subagent can access |

### Convergence Criteria
Stop improvement loops when:
- 3 consecutive successes achieved, OR
- No measurable improvement over N iterations, OR
- Resource budget exhausted

---

## Pattern 7: Self-Diagnosis Protocol

When encountering a novel problem:

1. **Classify** — Code bug, config issue, environment problem, or knowledge gap?
2. **Isolate** — Create minimal reproduction. What's the smallest failing case?
3. **Investigate** — Root cause before fixing (follow `systematic-debugging` skill)
4. **Solve** — Fix at the source, not the symptom
5. **Encode** — Save the solution pattern so this specific problem never costs time again

---

## Pattern 8: Longitudinal Compounding Metrics

Track improvement across ≥3 orthogonal dimensions simultaneously:

| Metric | Why |
|--------|-----|
| **Pass rate** (task completion) | Core capability |
| **Token cost per task** | Efficiency |
| **Iteration count** | Directness |
| **Regression rate** | Stability |
| **Time to first fix** | Debugging speed |
| **Memory utilization** | Knowledge effectiveness |

**Compounding requires improvement across ≥2 dimensions simultaneously.**
Use moving averages (7/30-day) to filter noise and identify true inflection points.

### The Compound Effect
```
Week 1:  Basic tools established
Week 2:  Skills improved from gaps found → 20% faster
Week 4:  Knowledge accumulation reduces repeat errors → 40% fewer iterations
Week 8:  Prompt optimization saves tokens → 60% more iterations per budget
Week 12: Meta-learning converges → agent approaches optimal strategy
```

---

## Pattern 9: Meta-Learning (New)

Agents should learn to adjust their own:
- **Search breadth** — How many alternatives to explore
- **Reflection depth** — How much analysis to do before acting
- **Tool selection** — Which tools to try first based on task type
- **Compute allocation** — Based on task difficulty signals (repo size, ambiguity, dependency density)

Use lightweight decision rules: if task complexity is high → more exploration; if low → fast execution.

---

## Usage

During any task:
1. **Before:** Search for relevant past solutions (session_search) and load matching skills
2. **During:** Archive durable facts immediately, use structured error parsing on failures
3. **After:** Create/update skills, sync knowledge to brain, update relevant memory
4. **Weekly:** Review accumulated knowledge, update utility scores, supersede stale facts, extract new patterns

---

## Remember

```
Every task teaches something
Save what works, learn from what doesn't
Guardrails enable bolder improvement
Knowledge compounds across sessions
Track orthogonal metrics — don't game one metric at the expense of others
```

**The agent that learns from every task is orders of magnitude more effective than one that doesn't.**

---

## Honcho Multi-Context Memory Integration

When operating across multiple profiles, projects, and sessions, use Honcho for structured persistent memory:

### Agent-as-Curator Pattern
Honcho is a storage/retrieval substrate — the **agent** must implement filtering, tagging, and lifecycle logic.

### Multi-Context Strategies
- **Per-project**: Use distinct `app_id` per project + `project:name` metadata tag. Enforce project-scoped queries to prevent cross-project contamination.
- **Per-user**: Anchor to `user_id` with namespace in metadata (`preferences`, `communication_style`).
- **Cross-session continuity**: Create a `context:global` session per user. Copy high-value session memories into it. Prune stale entries via TTL.
- **Memory curation**: At conversation end, summarize → deduplicate → tag → upsert. Never raw-log.

### Retrieval Tiers
1. **High**: Metadata match + semantic similarity — inject into system prompt
2. **Medium**: Semantic only — inject into tool context
3. **Low**: Fallback — fetch on-demand when needed

### Deduplication
Run semantic similarity check before saving new memory. If `similarity > 0.85`, merge or skip. Honcho does **not** auto-merge conflicts — explicit `memory_id` update required.
