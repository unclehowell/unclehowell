---
name: lessons-learned-2026-04-07
description: Lessons from file management and AWS server interaction tasks
version: 1.0.0
author: OpenCode Agent
metadata:
  hermes:
    tags: [lessons-learned, file-management, aws, troubleshooting]
    related_skills: [brain-audit-cycle]
---

# Lessons Learned - 2026-04-07

## Critical Rules for File Operations

### Never Delete Without Explicit Permission
- **Rule:** NEVER delete files, especially hidden directories, without explicit user consent
- **Context:** User emphasized brain folder importance multiple times in the past week
- **Lesson:** When asked to remove something, verify content first. Hidden directories like `.brain` can contain critical data
- **Recovery:** `rm -rf` is irreversible - no trash, no recovery unless using file recovery tools (testdisk/photorec)

### Verify Before Move Operations
- Always check source AND destination before moving files
- Compare sizes to detect duplicates or incomplete moves
- Check for "half-moved" states where files exist in both locations

## AWS Server Interaction

### Finding SSH Credentials
- **Pattern:** Always check `~/.bash_history` for SSH commands when connecting to remote servers
- **Keys found:** Look for `-i` flag with key path (e.g., `~/.ssh/paperclip-hermes-nvidia-key.pem`)
- **IP resolution:** Use `nslookup` or `dig` to resolve subdomains to IP addresses

### Understanding "command.{domain}"
- **Pattern:** When user says "command.abc.xyz" - they mean the subdomain
- **Discovery:** Use DNS lookup to find the IP, then SSH with key from history

### AWS Server Web Root
- **Key insight:** On THIS AWS server, web root is `/var/www/`, NOT `/var/www/html`
- **Server structure:**
  ```
  /var/www/
  ├── avatar-system/   (Node.js app)
  ├── datro-gui/      (datro front-end)
  ├── datro-ui/       (datro front-end - newer)
  ├── html/           (empty!)
  └── links/          (index.html)
  ```
- **Why this matters:** Don't assume /var/www/html is the web root - check nginx config

### Nginx Config Pattern
```bash
# Check which folder serves the site
cat /etc/nginx/sites-enabled/*
# Look for server_name directive to match subdomain
```

## User Communication Patterns

### Clues in Plain Sight
- User says "aws" then "command" - combine these: it's command.financecheque.uk
- User asks to "figure out" - means use available tools (DNS, SSH, history)
- When uncertain, ask clarifying questions before taking action

## Action Items for Future

1. Always `ls -la` before deleting anything
2. Check `~/.bash_history` first for remote server credentials
3. Verify web root location per-server (not assume standard paths)
4. When moving directories, check sizes to ensure complete move
5. Never use `rm -rf` on assumptions - confirm with user first