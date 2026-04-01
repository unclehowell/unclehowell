---
name: plan
description: Generate and manage execution plans for complex tasks.
version: 1.0.0
author: unclehowell
license: MIT
metadata:
  hermes:
    tags: [Planning, Project Management, Software Development]
    requires_tools: [todo]
---

# Plan Skill

This skill assists in generating and managing execution plans for complex tasks by breaking them down into actionable steps.

## When to Use
- Orchestrating multi-step software development tasks.
- Managing dependencies between sub-tasks.
- Tracking progress of a long-running project.

## Quick Reference
| Task | Action |
|------|--------|
| Create Plan | "Create a plan to [goal]" |
| Add Task | "Add [task] to the plan" |
| Update Status | "Mark task [N] as [status]" |

## Procedure
1.  **Goal Identification:** Clarify the ultimate objective with the user.
2.  **Decomposition:** Break the goal into discrete, manageable sub-tasks.
3.  **Dependency Mapping:** Order tasks based on what must be finished first.
4.  **Tracking:** Use the `todo` tool to record and update task statuses.
5.  **Refinement:** Adjust the plan as new information or obstacles arise.

## Pitfalls
- **Over-complication:** Breaking tasks into too many tiny steps can be noisy.
- **Under-specification:** Vague tasks lead to execution errors.
- **Stale Plans:** Failing to update task status leads to confusion.

## Verification
- For plan existence: `todo list`
- For task completion: Verify the behavioral change or output of the task.
