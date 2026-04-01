# OpenJarvis Installation Guide

This guide provides instructions on how to install and set up OpenJarvis on your system.

## Prerequisites

Before you begin, ensure you have the following installed:
- **Python 3.9+**: OpenJarvis is developed using Python.
- **pip**: The Python package installer.
- **Git**: For cloning the repository.
- **Node.js and npm (optional)**: Required for certain advanced features or integrations, such as browser automation.

## Installation Steps

### Option 1: Using pip (Recommended)

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/OpenJarvis/OpenJarvis.git
    cd OpenJarvis
    ```

2.  **Create a virtual environment:**
    ```bash
    python -m venv venv
    # Activate the virtual environment:
    # On Linux/macOS:
    source venv/bin/activate
    # On Windows:
    # .\venv\Scripts\activate
    ```

3.  **Install OpenJarvis:**
    ```bash
    pip install -e .
    ```
    To install with optional dependencies (e.g., for browser tools):
    ```bash
    pip install -e ".[all]"
    ```

### Option 2: Docker

OpenJarvis provides a Docker image for easier deployment.

1.  **Build the Docker image:**
    ```bash
    docker build -t openjarvis .
    ```

2.  **Run the Docker container:**
    ```bash
    docker run -it --rm openjarvis
    ```
    You may need to mount volumes for persistent storage or configuration.

## Configuration

After installation, you need to configure OpenJarvis:

1.  **API Keys:** Set up your API keys for LLM providers and other services. This is typically done via environment variables or a configuration file.
    ```bash
    export OPENAI_API_KEY='your-openai-api-key'
    export OPENROUTER_API_KEY='your-openrouter-api-key'
    ```
    Or, create a `.env` file in the project root.

2.  **Configuration File:** Copy `cli-config.yaml.example` to `config.yaml` and adjust settings as needed.
    ```bash
    cp cli-config.yaml.example config.yaml
    # Edit config.yaml with your preferred settings
    ```

## Verification

After installation and configuration, verify that OpenJarvis is working correctly:

```bash
hermes doctor
hermes status
hermes chat -q "Hello, how can you help me today?"
```

## Troubleshooting

If you encounter issues during installation or setup, please refer to the troubleshooting section in the [documentation](https://openjarvis.readthedocs.io/en/latest/troubleshooting) or open an issue on GitHub.