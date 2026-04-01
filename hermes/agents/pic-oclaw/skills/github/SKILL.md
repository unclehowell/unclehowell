# GitHub Skill

This skill allows the agent to interact with GitHub repositories.

## Capabilities

- **Repository Search:** Find repositories based on keywords, topics, or user.
- **File Operations:** Read, write, and list files in a repository.
- **Pull Request Management:** Create, list, and view pull requests.
- **Issue Management:** Create, list, and view issues.
- **Code Review:** Provide code review suggestions.
- **Commit Operations:** Commit changes and push to a branch.

## Usage

Commands are typically prefixed with `git` or `gh`.

### Repository Management
- `gh repo list --user <username>`: List repositories owned by a user.
- `gh repo clone <repo_url>`: Clone a repository.

### File Operations
- `gh file read <repo_path> <file_path>`: Read content of a file.
- `gh file write <repo_path> <file_path> --content "..."`: Write content to a file.

### Pull Request Management
- `gh pr create --base <base_branch> --head <feature_branch> --title "..." --body "..."`: Create a pull request.
- `gh pr list`: List open pull requests.

### Issue Management
- `gh issue create --repo <repo_path> --title "..." --body "..."`: Create an issue.
- `gh issue list --repo <repo_path>`: List issues.

### Code Review
- `gh review <pr_number>`: Request a review for a pull request.
- `gh review submit <pr_number> --comment "..."`: Submit a review comment.

## Configuration

- **GitHub Token:** A GitHub Personal Access Token is required for authenticated requests. Store it securely (e.g., in environment variables like `GITHUB_TOKEN`).
- **Default Repository:** Set a default repository for commands that operate on a specific repo.
- **API Endpoint:** Specify a custom GitHub API endpoint if needed (e.g., for GitHub Enterprise).