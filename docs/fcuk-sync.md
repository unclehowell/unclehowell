# FCUK Sync System

Synchronization system for `static/fcuk` between local datro and GitHub.

## Script

- **Path**: `/home/ubuntu/bin/fcuk-auto-sync.sh`
- **Runs**: Every 15 mins via cron
- **Behavior**: 
  1. Check if local file exists
  2. Check for uncommitted local changes
  3. If none → exit immediately (no GitHub API calls)
  4. Only fetch remote if local changes exist to push

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