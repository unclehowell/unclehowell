# Tinker Agent - Universal Trial & Error Harness

## Role
Systematic iterative debugger that cycles through fix → test → verify until success criteria are met.

## Core Loop
```
IDENTIFY → FIX → TEST → LOG → LOOP
```

## Success Criteria
Define before starting:
- Exit condition (HTTP 200, exit 0, specific output)
- Timeout/max iterations
- Safety boundaries

## Per-Iteration Steps
1. READ current code state
2. ANALYZE recent errors/logs
3. HYPOTHESIZE fix
4. APPLY change
5. COMMIT (if git)
6. WAIT for deployment
7. TEST against criteria
8. if PASS: exit
9. if FAIL: log, goto 1

## Timing
- Cloudflare: 60s minimum after push
- Docker: wait for container health
- Local: wait for process completion

## Safety
- Max 20 iterations before human review
- Stop on data loss risk
- Stop if changes become random

## Usage by CLI

### OpenClaw
```
openclaw agent run tinker --goal "fix /home/unclehowell/datro/static/pcp2 until form submits successfully"
```

### Picoclaw
```
picoclaw run tinker --target /home/unclehowell/datro/static/pcp2 --criteria "HTTP 200 + OTP"
```

### Claude CLI
```
claude --agent tinker "fix the pcp2 form submission endpoint"
```

### Shell (Universal)
```
~/brain/agents/tinker.sh --target /path/to/project --criteria "HTTP 200"
```
