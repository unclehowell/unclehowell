# 2026-04-07 - OpenCode MCP Setup

MCP servers installed via npm:
- @modelcontextprotocol/server-filesystem ✓
- @modelcontextprotocol/server-memory ✓
- @modelcontextprotocol/server-everything ✗ (broken, disabled)
- @modelcontextprotocol/server-sequential-thinking ✓

Honcho configured as memory provider:
- API key set: REMOVED-FROM-PUBLIC-BRAIN
- Config in: ~/.hermes/config.yaml -> memory_providers section

Binary location: ~/.npm-global/bin/mcp-server-*

3/4 working. Everything server fails on connection.
