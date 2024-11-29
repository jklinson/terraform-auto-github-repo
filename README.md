# GitHub Repository Creation with Terraform & GitHub Actions

This repository provides an automated way to create multiple GitHub repositories using Terraform and GitHub Actions. It reads repository configurations from a JSON file, and then uses Terraform to create the repositories on GitHub. This process is automated using GitHub Actions, which ensures that repositories are created, updated, and managed efficiently.

## Features

- **Multiple Repository Creation**: Configure multiple repositories in a JSON file and create them in bulk.
- **Automation with GitHub Actions**: Trigger the process using GitHub Actions, which can be invoked via an API or manually.
- **Repository Existence Check**: Avoids recreating existing repositories with Terraform's built-in lifecycle rules.

## Prerequisites

- **Terraform**: Make sure you have Terraform installed locally if you plan to run it outside of GitHub Actions.
- **GitHub Token**: You need a GitHub Personal Access Token (PAT) with repository creation permissions.
- **GitHub Actions**: GitHub Actions are used to automate the process.

## Setup Instructions

### 1. Clone the Repository

First, clone this repository to your local machine or set it up in your own GitHub account.

```bash
git clone https://github.com:jklinson/terraform-auto-github-repo.git
cd terraform-auto-github-repo
```

### 2. Configure the JSON File

The repository configuration is stored in the `repositories.json` file. This file contains an array of objects with the necessary details for each repository you'd like to create.

#### Example `repositories.json`:

```json
[
  {
    "name": "repo-1",
    "description": "This is the first repository",
    "private": true,
    "visibility": "private"
  },
  {
    "name": "repo-2",
    "description": "This is the second repository",
    "private": false,
    "visibility": "public"
  }
]
```

You can add as many repository configurations as needed to the JSON array.

### 3. Add Your GitHub Token

To authenticate Terraform with GitHub, you'll need to set up a GitHub Personal Access Token (PAT). The token should have permissions to create repositories.

#### Add the Token to GitHub Secrets:

1. Go to your GitHub repository.
2. Navigate to **Settings > Secrets and Variables > Actions**.
3. Add a new repository secret with the name `GITHUB_TOKEN` and the value of your PAT.

Alternatively, you can set the `GITHUB_TOKEN` as an environment variable in your local machine if you're running Terraform outside of GitHub Actions.

### 4. Configure Terraform Variables

You can configure Terraform variables in a `terraform.tfvars` file or pass them directly as environment variables. Here's an example `terraform.tfvars` file:

```hcl
github_token = "your-github-token"
```

Make sure that your GitHub Token has the following permissions:
- `repo` (for private repositories)
- `admin:repo_hook` (for webhook management, if needed)

### 5. Using GitHub Actions

#### Triggering the Workflow

The repository includes a GitHub Actions workflow located in `.github/workflows/terraform.yml`. This workflow is triggered using the `workflow_dispatch` event, which means you can manually trigger it via the GitHub UI or via GitHub API.

To trigger the workflow manually:

1. Go to **Actions** tab in your GitHub repository.
2. Select the `Terraform GitHub Repository Creation` workflow.
3. Click **Run workflow**.

Alternatively, you can trigger the workflow via the GitHub API:

```bash
curl -X POST -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/YOUR_USERNAME/YOUR_REPOSITORY/actions/workflows/terraform.yml/dispatches \
  -d '{"ref":"main"}'
```

### 6. Terraform Workflow

When the GitHub Action is triggered, it performs the following steps:

1. **Checkout the repository code**.
2. **Set up Terraform**: Installs Terraform.
3. **Terraform Init**: Initializes Terraform.
4. **Terraform Plan**: Generates an execution plan, previewing the changes that will be made.
5. **Terraform Apply**: Applies the plan to create the repositories.
6. **Output Terraform State**: Optionally, outputs the Terraform state or any relevant information.

The repositories listed in the `repositories.json` file will be created on GitHub, provided they do not already exist.

### 7. Local Execution (Optional)

If you prefer to run Terraform locally (instead of using GitHub Actions), follow these steps:

1. **Install Terraform**: Download and install Terraform from [terraform.io](https://www.terraform.io/downloads).
2. **Initialize Terraform**: Run the following command to initialize Terraform.

   ```bash
   terraform init
   ```

3. **Generate the Plan**: Generate the Terraform execution plan.

   ```bash
   terraform plan -out=tfplan
   ```

4. **Apply the Plan**: Apply the generated plan to create the repositories.

   ```bash
   terraform apply -auto-approve tfplan
   ```

### 8. Notes

- **Repository Existence Check**: Terraform does not have a built-in check to prevent the creation of already existing repositories. However, the `prevent_destroy = true` lifecycle rule ensures that Terraform won't accidentally destroy any existing repositories.
- **Custom Configurations**: You can customize the `repositories.json` file to include any additional fields supported by the `github_repository` resource (e.g., `has_issues`, `has_projects`, `has_wiki`, etc.).
- **Error Handling**: If a repository already exists, Terraform will not attempt to recreate it. If you encounter any issues, check the output logs for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to contribute by opening an issue or submitting a pull request.
