---
name: recursive-self-improvement
description: Patterns for compounding self-improvement in AI coding agents. Covers feedback loop design, knowledge accumulation, skill evolution, prompt optimization, and safe self-modification through sandboxed validation cycles.
version: 1.0.0
author: Hermes Agent
metadata:
  hermes:
    tags: [self-improvement, meta-cognition, optimization, learning, feedback-loops]
    related_skills: [2nd-brain, brain-sync, systematic-debugging, subagent-driven-development]
---

# Recursive Self-Improvement for AI Agents

## Core Principle

Compounding improvement occurs when gains in one subsystem unlock safer, more aggressive improvements in others. Each improvement raises the baseline, enabling the next level. Build **closed-loop validation** and **permanent anchors** that make the agent progressively better with every task.

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

## Pattern 1: Tight Feedback Loops

Every task should follow this cycle:
1. **Generate** — Produce output (code, plan, analysis)
2. **Execute** — Run it in a sandboxed environment
3. **Evaluate** — Measure against objective criteria (tests pass? lint clean? matches spec?)
4. **Refine** — If it fails, diagnose, fix, repeat
5. **Archive** — Save the successful pattern for future reuse

**Speed matters:** < 10s for unit-level loops, < 2m for integration loops.

```python
# Example: self-debugging loop
for attempt in range(3):
    terminal("pytest tests/ -q")  # Execute
    if exit_code == 0:
        break                       # Evaluate: pass
    # Diagnose, refine, retry
```

---

## Pattern 2: Knowledge Accumulation

### Three-Tier Memory
| Tier | What | How |
|------|------|-----|
| **Facts** | Durable domain knowledge | Save to brain files / Hermes memory tool |
| **Procedures** | How to do things | Create/update skills |
| **Meta** | What improves performance | Update this skill's knowledge |

### When to Archive
After every non-trivial task (5+ tool calls):
- What worked (successful patterns)
- What failed (errors and root causes)
- What was discovered (environment facts, API quirks)
- What was created (new skills, updated files)

### Decay and Maintenance
Weekly, review accumulated knowledge:
- Supersede outdated facts (don't delete — mark `status: superseded`)
- Identify patterns that appear 3+ times → extract to a new rule/skill
- Remove contradictions and garbage

---

## Pattern 3: Prompt Engineering Through Experience

### Dynamic Few-Shot Retrieval
Before tackling a task, search past sessions and brain files for:
- Similar tasks and how they were solved
- Common pitfalls and how they were avoided
- Working code patterns in the same codebase

```
session_search(query="similar task keywords OR related terms")
# Review what worked, extract patterns
```

### Prompt Versioning
Track which prompting strategies work best:
- Direct instruction vs. step-by-step
- Role-playing vs. plain language
- Few-shot examples vs. zero-shot

When you find a strategy that consistently works better for a task type, update relevant skills.

---

## Pattern 4: Test-First Safety

The most important anchor for self-improvement:

```
Write tests BEFORE implementing → Tests become permanent guardrails → 
Can refactor aggressively → Tests catch regressions → More confidence → 
Bolder improvements → Better code → Cycle repeats
```

**Every improvement to the agent's own code, scripts, or configs should have tests first.**

---

## Pattern 5: Skill Evolution

### When to Create a New Skill
- Successfully completed a complex task (5+ tool calls)
- Discovered a non-trivial workflow
- Overcame an error through investigation
- Found a pattern worth reusing

### When to Update a Skill
- Used a skill and found missing steps
- Used a skill and hit issues not covered
- Found a pitfall the skill didn't warn about
- Environment changed (files moved, APIs updated)

### The Improvement Cycle
```
Use skill → find gaps → patch skill immediately → 
next use is better → compound improvement
```

---

## Pattern 6: Safety and Guardrails

Recursive self-improvement requires guardrails:

| Guardrail | Implementation |
|-----------|---------------|
| **Sandboxed execution** | Use `execute_code` and `terminal` with isolated contexts |
| **Diff validation** | Review changes before applying. Never skip review for self-modifications. |
| **Version control** | Git commit before major changes. Can revert if something breaks. |
| **Human gates** | Production changes require approval. Agent handles dev/test autonomously. |
| **Convergence criteria** | Stop after 3 consecutive successes, or no improvement over N iterations |
| **No reward hacking** | Don't delete tests to pass. Don't skip quality gates. Enforce coverage floors. |

---

## Pattern 7: Self-Diagnosis Protocol

When the agent encounters a problem it hasn't seen before:

1. **Classify** — Is this a code bug, config issue, environment problem, or knowledge gap?
2. **Isolate** — Create minimal reproduction. What's the smallest failing case?
3. **Investigate** — Follow `systematic-debugging` skill. Root cause before fixing.
4. **Solve** — Fix at the source, not the symptom.
5. **Encode** — Save the solution pattern so this specific problem never costs time again.

---

## Pattern 8: Compounding Dynamics

### How Subsystems Reinforce Each Other

| If you improve... | It makes these better... |
|-------------------|--------------------------|
| Test coverage | Refactoring safety, debugging speed |
| Debugging skills | Knowledge base, future speed |
| Prompt quality | Token efficiency, more iterations |
| Tool knowledge | Problem-solving breadth |
| Code quality | Review speed, maintenance cost |
| Memory hygiene | Recall accuracy, context relevance |

### The Compound Effect
```
Week 1: Basic tools established
Week 2: Skills improved from gaps found → 20% faster
Week 4: Knowledge accumulation reduces repeat errors → 40% faster
Week 8: Prompt optimization saves tokens → 60% more iterations per budget
Week 12: Meta-learning converges → agent approaches optimal strategy
```

---

## Usage

During any task:
1. **Before:** Search for relevant past solutions and patterns
2. **During:** Archive durable facts and discoveries immediately
3. **After:** Create/update skills, sync knowledge to brain
4. **Weekly:** Review accumulated knowledge, supersede stale facts, extract new patterns

---

## Remember

```
Every task teaches something
Save what works, learn from what doesn't
Guardrails enable bolder improvement
Knowledge compounds across sessions
```

**The agent that learns from every task is orders of magnitude more effective than one that doesn't.**
