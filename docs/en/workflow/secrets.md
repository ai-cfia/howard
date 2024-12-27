# Secret leak detection workflow and gitHub token management

This document provides an overview of the secret leak detection workflow,
outlining its purpose, functionality, and usage guidelines. This workflow is
designed to identify potential secret leaks in the source code of repositories.

## Workflow: Secret leak detection

### Purpose

The workflow automates the detection of potentially exposed secrets in the
repository through rigorous code analysis. It uses tools to authenticate and
retrieve secured secrets from a secret manager before analysis.

### Trigger

The workflow is triggered on every `push` to any branch and can be called via
`workflow_call`.

### Steps

1. **Clone the Code**:
   - Uses `actions/checkout@v3` to clone the source code from the repository to
   the runner's working environment.

2. **Authenticate and Retrieve Secrets from Vault**:
   - Uses the `hashicorp/vault-action@v3.0.0` action to authenticate with Vault
   using GitHub OIDC and retrieve necessary secrets. To add new secret paths,
   suchas a directory for `nachet`, simply add a new line in the secret
   configuration:

   ```yaml
   secrets: |
     kv/data/test * | VAULTACTIONKEY_;
     kv/data/nachet * | VAULTACTIONKEY_;
   ```

3. **Install git-secrets** :
    - Installs the git-secrets tool to facilitate the detection of secrets in
    the code.

4. **Add API keys to git-secrets** :
    - Adds the retrieved API keys to git-secrets to be used as patterns in the
    analysis.

5. **Scan the repository for secret detection** :
    - Executes a scan of the repository for exposed secrets using git-secrets.

6. **Remove git-secrets patterns** :
    - Cleans up the git-secrets configurations after the scan by removing the
    configuration sections.

## GitHub token management

This section documents the secrets used in all our GitHub workflows and the
cluster.

- **VAULT_TOKEN** : Used by the detect secret leaks workflow. For more information
on how to get the token, see
<https://developer.hashicorp.com/vault/docs/auth/github>
- **GH_WORKFLOW_APP_ID** and **GH_WORKFLOW_APP_PEM** : See information about the
GitHub app `GH app for workflows` inside the `ai-cfia` org.
- **DEVOPS_USER** and **DEVOPS_USER_TOKEN** : Used by the
<https://github.com/ai-cfia/devops/blob/main/.github/workflows/github-metrics-workflow.yml>
workflow.
- **GITHUB_GRAFANA_DASHBAORD** : Used by <https://grafana.inspection.alpha.canada.ca>
for the github datasource.
- **AILAB_OCTOKIT_ACCESS_TOKEN** : Used by the
<https://github.com/ai-cfia/github-workflows/blob/main/.github/workflows/workflow-repo-standards-validation.yml>
workflow.

### Usage

To use this workflow:

- Let it run automatically on each push to the branches, or manually trigger it as
needed via workflow_call.
- Ensure that the required secrets are correctly configured in the repository settings.
