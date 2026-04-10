# FCUK Sync System

Synchronization system for `static/fcuk` between local datro and GitHub.

## Script

- **Path**: `/home/ubuntu/bin/fcuk-auto-sync.sh`
- **Runs**: Every 15 mins via cron
- **Behavior**: 
  1. Fetch remote to get latest state
  2. Compare local HEAD vs remote HEAD
  3. Check for uncommitted local changes
  4. Determine sync direction:
     - Both unchanged → exit (no API calls)
     - Remote ahead → pull
     - Local changes only → push
     - Both changed → merge then push

## Multi-Machine Sync (2026-04-10)
Handles multiple machines (server + laptop) gracefully:
- Fetches remote first
- Detects if remote has new commits
- Merges local + remote before pushing

## Key Improvement (2026-04-10)
- Optimized: Exits immediately if nothing to sync
- No unnecessary GitHub API calls
- No email notifications (by request)

## Cron Entry
```cron
*/15 * * * * /home/ubuntu/bin/fcuk-auto-sync.sh >> /home/ubuntu/logs/fcuk-auto-sync.cron.log 2>&1
```

## Log Location
- `/home/ubuntu/logs/fcuk-auto-sync.log` - sync operations
- `/home/ubuntu/logs/fcuk-auto-sync.cron.log` - cron execution