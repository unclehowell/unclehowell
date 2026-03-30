# Claude Integration

OpenRoom integrates with Claude models via the Anthropic API.

## Features

- **Model Access:** Supports various Claude models (e.g., Claude 3 Opus, Sonnet, Haiku).
- **API Key Management:** Securely handles Anthropic API keys.
- **Context Management:** Optimized for Claude's context window limitations.
- **Tool Usage:** Enables Claude models to use available tools and skills.

## Configuration

To enable Claude integration, you need to set your Anthropic API key. This can be done via:

1.  **Environment Variable:**
    ```bash
    export ANTHROPIC_API_KEY='your-anthropic-api-key'
    ```

2.  **Configuration File:** Add the key to your `~/.openjarvis/config.yaml` or `.env` file.

## Usage Examples

When configuring an agent, specify a Claude model:

```yaml
agents:
  my-claude-agent:
    model: "anthropic/claude-3-opus-20240229"
    # ... other configurations
```

Or use it directly via the CLI:
```bash
hermes chat --model anthropic/claude-3-sonnet-20240229 "Explain the concept of emergent properties."
```

## Notes

- Ensure your API key is kept secure and is not committed to version control.
- Check Anthropic's documentation for the latest model availability and pricing.
