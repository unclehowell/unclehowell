# Contributing to Firecrawl

We are excited to have you contribute to Firecrawl! We welcome all contributions, from bug reports and feature requests to code submissions and documentation improvements.

## How to Contribute

### Reporting Issues

Before reporting a bug, please check the [existing issues](https://github.com/firecrawl/firecrawl-api/issues) to see if it has already been reported. If not, please open a new issue with a detailed description of the bug, including:
- Steps to reproduce the issue
- Your environment (OS, Python version, Firecrawl version)
- Relevant logs or error messages

### Suggesting Features

Have an idea for a new feature or improvement? Open an issue to discuss it.

### Submitting Code

1.  **Fork the repository:** Create your own fork of the Firecrawl repository.
2.  **Clone your fork:**
    ```bash
    git clone https://github.com/your-username/firecrawl-api.git
    cd firecrawl-api
    ```
3.  **Create a new branch:**
    ```bash
    git checkout -b feature/your-feature-name
    # or for a bug fix:
    # git checkout -b bugfix/your-bug-fix
    ```
4.  **Make your changes:** Write your code and ensure it follows the project's coding style.
5.  **Add tests:** Write unit tests to cover your changes.
6.  **Commit your changes:** Use conventional commits (e.g., `feat:`, `fix:`, `docs:`).
    ```bash
    git commit -m "feat: Add new feature for X"
    ```
7.  **Push to your fork:**
    ```bash
    git push origin your-branch-name
    ```
8.  **Open a Pull Request:** Submit a pull request to the main repository.

### Code Style

Please adhere to the existing code style, which is enforced by `black` and `ruff`. You can run the linters locally:

```bash
ruff check .
black .
```

We recommend setting up pre-commit hooks for automatic checks.

### License

By contributing, you agree that your contributions will be licensed under the [Apache 2.0 License](LICENSE).

---

Thank you for contributing to Firecrawl!