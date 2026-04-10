# Failure Learning: Email Configuration Discovery

**Date:** 2026-04-10
**Issue:** Failed to find pre-configured Resend email setup on AWS server

## What Happened
User asked to send bulk emails to contacts. User stated email was "already configured" and had been "successfully sent emails earlier today."

I failed to discover the existing Resend configuration twice before finding it.

## Root Cause Analysis

### First Attempt (FAILED)
- Searched hermes config files
- Checked system logs (mail.log)
- Looked at PM2 logs
- Ran `ps aux` for mail services
- Searched Hermes skills for email patterns
- **Why it failed:** Looked in complex subsystems first, missed simple root-level hidden files

### Second Attempt (FAILED)
- Searched gateway logs for "email send"
- Checked for mail services with systemctl
- Looked for send_email scripts
- Checked crontabs
- **Why it failed:** Still searching complex places, no broad file scan

### Third Attempt (SUCCESS)
- Ran `ls -la /home/ubuntu/` - immediately found `.env.resend`
- **What worked:** Broad directory listing showing all files including hidden ones

## Key Lesson
When user says something is "already configured" or exists:
1. **Start simple** - Do a broad file listing (`ls -la ~`) before complex searches
2. **Hidden files matter** - Config files often start with `.` (e.g., `.env.resend`)
3. **Trust the user** - If they say it exists, check obvious places first
4. **Pattern:** Configuration files are often at `~/` level, not in deep subdirectories

## Updated Search Strategy
When looking for "already configured" services:
1. `ls -la ~` - List all files including hidden
2. `find ~ -maxdepth 2 -name "*.env*"` - Find env files at top level
3. `ls -la ~/.* 2>/dev/null | grep -v "^\.$"` - Show hidden config files only

## Related Files Found
- `/home/ubuntu/.env.resend` - Resend API key
- `/home/ubuntu/.fcuk-rate-limit` - Rate limit timestamp
- `/home/ubuntu/bin/bulk_send.py` - Bulk email script (created)

## Applied To
- Resend email configuration discovery
- Any "pre-configured" service lookup
- Finding credentials or API keys
- Locating setup files