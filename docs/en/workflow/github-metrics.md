# GitHub Metrics Workflow

This document provides an overview of the GitHub metrics workflow, including
its purpose, functionality, and guidelines for usage. This workflow is designed
to generate a report of GitHub metrics within a specified date range.

## Workflow: Generate GitHub Metrics Report

### Purpose

The workflow automates the process of generating a metrics report for selected
GitHub repositories and members over a specified period. The generated report
is uploaded as a PDF artifact.

### Trigger

The workflow is executed manually via `workflow_dispatch`, which requires
specific inputs:

- **start_date** (string): The beginning of the date range for the report
(format: yyyy-mm-dd).
- **end_date** (string): The end of the date range for the report
(format: yyyy-mm-dd).
- **selected_members** (string): Comma-separated list of GitHub members to
include in the report. Defaults to '*' (all members).
- **selected_repositories** (string): Comma-separated list of repositories to
include in the report. Defaults to '*' (all repositories).

### Steps

1. **Generate Token from GitHub Application**:
   - Uses a GitHub app to create an authentication token for accessing
   metrics data.

2. **Checkout the Repository**:
   - Checks out the current repository to the workflow
   runner.

3. **Set Up Python Environment**:
   - Configures the Python environment with version 3.8 for running
   the metrics script.

4. **Install Custom Package**:
   - Installs a package from GitHub containing necessary scripts for
   metrics extraction.

5. **Access User Site-Packages**:
   - Determines the path to the Python site-packages directory for the
   installed scripts.

6. **Install Dependencies**:
   - Installs additional dependencies listed in `requirements.txt`.

7. **Run GitHub Metrics Script**:
   - Executes the metrics script using environment variables configured with
   the provided inputs.

8. **Upload PDF Artifact**:
   - Uploads the generated PDF report as an artifact, naming it based on the
   specified date range.

### Configuration

#### Environment Variables

- **GITHUB_ACCESS_TOKEN**: Token generated for accessing GitHub data.
- **START_DATE**: Start date input for the report.
- **END_DATE**: End date input for the report.
- **SELECTED_REPOSITORIES**: Repositories specified for metrics extraction.
- **SELECTED_MEMBERS**: Members specified for metrics extraction.

### Usage

To use this workflow:

- Trigger it manually from the GitHub Actions tab.
- Provide the required inputs (`start_date`, `end_date`) and customize optional
inputs (`selected_members`, `selected_repositories`) as needed.

### Notes

- Ensure that secrets for `GH_WORKFLOW_APP_ID`, `GH_WORKFLOW_APP_PEM`,
`DEVOPS_USER`, and `DEVOPS_USER_TOKEN` are correctly configured in the
repository settings for secure authentication.

- The workflow relies on Python scripts hosted in a repository, which should be
accessible to the workflow through appropriate permissions.
