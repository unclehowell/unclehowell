#!/usr/bin/env python3
"""
Hermes Brain Bridge - Integrates Hermes with shared brain
This script should be called by Hermes to:
1. Pull latest brain before responding
2. Save learned lessons to brain after tasks
3. Query brain for relevant context before actions
"""

import os
import sys
import json
import subprocess
from pathlib import Path

BRAIN_DIR = "/home/unclehowell/brain"
MEMORY_DIR = f"{BRAIN_DIR}/memory"
LEARNED_DIR = f"{BRAIN_DIR}/memory/archive/learned"


def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip(), result.returncode


def pull_brain():
    """Pull latest from GitHub"""
    print("📥 Pulling latest brain...")
    run_cmd(
        f"cd {BRAIN_DIR} && git fetch origin && git reset --hard origin/main 2>/dev/null"
    )
    print("✅ Brain synced")


def save_lesson(lesson, category="hermes"):
    """Save a learned lesson to brain"""
    import datetime

    today = datetime.date.today().isoformat()
    filename = f"{LEARNED_DIR}/{today}/hermes.md"

    os.makedirs(f"{LEARNED_DIR}/{today}", exist_ok=True)

    with open(filename, "a") as f:
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        f.write(f"### {timestamp}\n{category}: {lesson}\n\n")

    print(f"💾 Lesson saved: {category}")

    # Auto-commit and push
    run_cmd(
        f"cd {BRAIN_DIR} && git add -A && git commit -m 'Hermes learning: {category}' && git push origin main 2>/dev/null"
    )


def recall(query):
    """Search brain for relevant info"""
    print(f"🔍 Searching brain for: {query}")

    # Search memory
    mem_results = []
    for md in Path(MEMORY_DIR).rglob("*.md"):
        content = md.read_text().lower()
        if query.lower() in content:
            mem_results.append(f"{md.name}: {content[:200]}")

    # Search learned
    learn_results = []
    for md in Path(LEARNED_DIR).rglob("*.md"):
        content = md.read_text().lower()
        if query.lower() in content:
            learn_results.append(f"{md.name}: {content[:200]}")

    results = mem_results + learn_results
    return results[:5] if results else ["No relevant memories found"]


def get_context():
    """Get full brain context for Hermes"""
    context = []

    # Core memory
    core_file = f"{BRAIN_DIR}/memory/core.md"
    if os.path.exists(core_file):
        context.append(f"=== CORE KNOWLEDGE ===\n{open(core_file).read()}")

    # Providers
    providers_file = f"{BRAIN_DIR}/providers.json"
    if os.path.exists(providers_file):
        context.append(f"=== PROVIDERS ===\n{open(providers_file).read()}")

    # Recent learned
    import datetime

    today = datetime.date.today().isoformat()
    learned_today = f"{LEARNED_DIR}/{today}/hermes.md"
    if os.path.exists(learned_today):
        context.append(f"=== TODAY'S LEARNINGS ===\n{open(learned_today).read()}")

    return "\n\n".join(context)


def main():
    if len(sys.argv) < 2:
        print("Usage: brain_bridge.py [pull|learn <category>|recall <query>|context]")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "pull":
        pull_brain()
    elif cmd == "learn":
        if len(sys.argv) < 3:
            print("Usage: brain_bridge.py learn <lesson> [category]")
            sys.exit(1)
        category = sys.argv[3] if len(sys.argv) > 3 else "general"
        save_lesson(sys.argv[2], category)
    elif cmd == "recall":
        if len(sys.argv) < 3:
            print("Usage: brain_bridge.py recall <query>")
            sys.exit(1)
        for r in recall(sys.argv[2]):
            print(r)
    elif cmd == "context":
        print(get_context())
    else:
        print(f"Unknown command: {cmd}")


if __name__ == "__main__":
    main()
