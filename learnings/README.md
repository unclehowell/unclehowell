# Learnings

Approved learnings that have been manually curated and sanitized for public sharing on GitHub.

## Purpose

This folder contains learnings that have been:
1. Originally captured in `memory/archive/learned/` (local, gitignored)
2. Reviewed and approved for public sharing
3. Sanitized of any sensitive information (no API keys, credentials, personal data, internal URLs)

## Structure

```
learnings/
├── README.md              # This file
├── YYYY-MM-DD-*.md       # Dated learning entries
└── topic/                # Optional: topic-based organization
```

## Contributing

### Adding New Learnings

1. **Capture**: Agents write raw learnings to `memory/archive/learned/` (gitignored)
2. **Review**: Human reviews the learning for:
   - Sensitive information removal (API keys, internal URLs, personal data)
   - Generalization of specifics where needed
   - Clarity and value for other agents/humans
3. **Migrate**: Copy sanitized version to `learnings/` with date prefix
4. **Sync**: Run `bash scripts/sync.sh` to push to GitHub

### Format

```markdown
# Learning: [Topic/Summary]

## Date
YYYY-MM-DD

## Context
Brief description of what triggered this learning

## Insight
The main learning point

## Application
How this can be applied to future work
```

## Examples

See existing learnings in this folder for examples of properly formatted entries.
