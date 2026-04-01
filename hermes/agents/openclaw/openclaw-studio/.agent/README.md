# Openclaw Studio Agent Configuration

This directory contains configuration files and settings specific to agents managed by Openclaw Studio.

## Agent Configuration Files

- **`personality.md`**: Defines the agent's persona, tone, and core instructions.
- **`instructions.md`**: High-level directives for the agent's behavior and goals.
- **`memory.md`**: Persistent memory for the agent, storing learned facts and user preferences.
- **`identity.md`**: Information about the agent itself, its name, purpose, and capabilities.
- **`skills.json`**: Configuration file for enabling and configuring agent skills.
- **`tools.json`**: Configuration for specific tools the agent can use.
- **`models.json`**: Specifies the LLM models the agent can access.
- **`channels.json`**: Configures communication channels for the agent.

## Example Structure

```
.agent/
├── personality.md
├── instructions.md
├── memory.md
├── identity.md
├── skills.json
├── tools.json
├── models.json
└── channels.json
```

## Key Files Explained

### `personality.md`
Defines the agent's core persona. This is what shapes its responses and interactions.

### `instructions.md`
Provides high-level directives and rules for the agent's operation.

### `memory.md`
Stores learned information and user preferences for long-term recall.

### `identity.md`
Details about the agent's name, description, purpose, and capabilities.

### `skills.json`
A JSON file listing skills available to the agent and their configurations.

```json
{
  "enabled_skills": [
    "web_search",
    "file_operations"
  ],
  "skill_configs": {
    "web_search": {
      "default_search_engine": "google"
    }
  }
}
```

## Best Practices

- Keep configuration files concise and well-documented.
- Use descriptive names for agents and skills.
- Regularly review and update agent configurations as needed.