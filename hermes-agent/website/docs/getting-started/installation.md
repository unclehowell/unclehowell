# Installation

Hermes Agent can be installed on Linux, macOS, and Windows. It requires Python 3.11+ and uv for package management.

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Git** | With `--recurse-submodules` support |
| **Python 3.11+** | uv will install it if missing |
| **uv** | Fast Python package manager ([install](https://docs.astral.sh/uv/)) |
| **Node.js 18+** | Optional — needed for browser tools and WhatsApp bridge |

## Clone and Install

```bash
# 1. Clone the repository, including submodules
git clone --recurse-submodules https://github.com/NousResearch/hermes-agent.git
cd hermes-agent

# 2. Create a virtual environment using uv
uv venv venv --python 3.11
# Activate the virtual environment (source it or run the generated script)
# Example for Linux/macOS:
source venv/bin/activate
# Example for Windows PowerShell:
# . venv/Scripts/Activate.ps1

# 3. Install dependencies
# Install with all extras (messaging, cron, CLI menus, dev tools)
uv pip install -e ".[all,dev]"

# Optional: Install browser tools (if you plan to use browser-based skills)
npm install

# Optional: Install RL training submodule (if needed)
# git submodule update --init tinker-atropos && uv pip install -e "./tinker-atropos"
```

## Configure for Development

After installation, you'll need to set up configuration files and environment variables.

```bash
# Create default configuration directories
mkdir -p ~/.hermes/{cron,sessions,logs,memories,skills}

# Copy the example config file
cp cli-config.yaml.example ~/.hermes/config.yaml

# Create a .env file for API keys and secrets
touch ~/.hermes/.env

# Add at minimum an LLM provider key to .env
echo 'OPENROUTER_API_KEY=sk-or-v1-your-key' >> ~/.hermes/.env
```

## Run Hermes

To make the `hermes` command globally accessible:

```bash
# Create a symlink for global access (Linux/macOS)
mkdir -p ~/.local/bin
ln -sf "$(pwd)/venv/bin/hermes" ~/.local/bin/hermes

# Verify the installation
hermes doctor
hermes chat -q "Hello"
```

## Run Tests

To ensure everything is working correctly, run the test suite:

```bash
pytest tests/ -v
```
