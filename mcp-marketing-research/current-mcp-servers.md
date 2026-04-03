# Current MCP Servers - Reference Document

## Existing Servers (DO NOT DUPLICATE)

| Server | Package | Purpose | Args |
|--------|---------|---------|------|
| brain | @modelcontextprotocol/server-filesystem | Access to brain directory | /home/unclehowell/brain |
| filesystem | @modelcontextprotocol/server-filesystem | General filesystem access | /home/unclehowell |
| memory-mcp | @modelcontextprotocol/server-memory | Knowledge graph memory | - |
| sequential-thinking | @modelcontextprotocol/server-sequential-thinking | Problem solving workflow | - |
| time | mcp-server-time | Time operations | - |

## Packages Already in Use
- @modelcontextprotocol/server-filesystem (used twice - different paths)
- @modelcontextprotocol/server-memory
- @modelcontextprotocol/server-sequential-thinking
- mcp-server-time (via uvx)

## When Adding New Servers
1. Check this document first - don't duplicate existing functionality
2. Verify package exists: `npm view <package>`
3. Check GitHub repo is maintained
4. Use unique server names (no collisions with built-in tools)
5. Test before committing
