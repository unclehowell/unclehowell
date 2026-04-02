---
name: brain-sync
description: Close the learning loop — archive session learnings to brain and sync to GitHub. Trigger after completing any non-trivial task (5+ tool calls, discovered new info, fixed errors).
---

# Brain Sync — Close The Loop

Run this at the end of every session.

## Steps

1. Write session summary to brain:
   mkdir -p /home/unclehowell/brain/memory/archive/learned/$(date +%Y-%m-%d)
   Write a brief .md file summarizing what was accomplished, what was learned,
   and any follow-ups needed.

2. Commit and push:
   bash /home/unclehowell/brain/scripts/sync.sh

3. If the sync script fails, do these manually:
   cd /home/unclehowell/brain
   git add -A
   git commit -m "Brain update: session summary"
   git push origin main

4. If still failing, note the failure for the next agent to retry.

## What to Archive

Always archive:
- Decisions made and why
- Errors encountered and how they were resolved
- New skills created
- Updated skills
- User corrections/preferences (also save via memory tool)
- Environment discoveries (tool paths, API quirks, etc.)

Never archive:
- API keys, passwords, or other secrets
- Temporary/ephemeral state

## When to Skip

- Quick one-shot answers with no new information
- Trivial conversations
