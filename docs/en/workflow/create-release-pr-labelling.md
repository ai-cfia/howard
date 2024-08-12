# Create release and label pull request

This document explains the purpose, functionality, and usage of the two GitHub
workflows provided. The workflows automate the process of creating releases
and labeling pull requests.

## Workflow (1): Create Release, Build and Push to GHCR with Specific Tag

### Purpose (1)

This workflow automates the following steps:

- **Create a GitHub Release:** It generates a release based on a tag pushed
to the repository.
- **Generate Changelog:** It uses the labels of merged pull requests to generate
a changelog.
- **Build and Push Docker Image:** It builds a Docker image and pushes it to
GitHub Container Registry (GHCR).

### Trigger (1)

The workflow is triggered manually via workflow_call with two required inputs:

- `artifact-name`: Name of the artifact to be created.
- `registry`: Registry where the Docker image will be pushed.

In most cases, the `workflow_call` is called as follows:

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
```

### Steps (1)

- **Checkout Repository:** Clones the repository.
- **Extract Tag Name:** Extracts the current tag name from the GitHub reference.
- **Generate Changelog:** Generates a changelog using merged pull requests.
- **Create Release:** Creates a GitHub release using the extracted tag and
generated changelog.
- **Upload Release Asset:** Zips the repository and uploads it as a release
asset.
- **Set up Docker Buildx:** Sets up Docker Buildx for building multi-platform
images.
- **Log in to GHCR:** Logs in to the GitHub Container Registry.
- **Cache Docker Layers:** Caches Docker layers to speed up the build process.
- **Build and Push Docker Image:** Builds and pushes the Docker image to GHCR.
- **Refresh Cache:** Refreshes the Docker cache.
- **Output Image Digest:** Outputs the image digest if the event is not a merged
pull request.

### Configuration (1)

The Generate changelog step uses the
`mikepenz/release-changelog-builder-action@v5` action to create a changelog based
on pull requests merged since the previous tag. This step categorizes pull
requests into different sections based on their labels.

```yaml
- name: Generate changelog
  id: changelog
  uses: mikepenz/release-changelog-builder-action@v5
  with:
    configurationJson: |
      {
          "categories": [
              {
                  "title": "## User stories 👑",
                  "labels": ["epic"]
              },
              {
                  "title": "## New features 🎉",
                  "labels": ["feature"]
              },
              {
                  "title": "## Bug fixes 🐛",
                  "labels": ["bug"]
              },
              {
                  "title": "## Documentation 📄",
                  "labels": ["documentation"]
              },
              {
                  "title": "## Other Changes 💬",
                  "labels": ["*"]
              }
          ],
          "template": "#{{CHANGELOG}}\n\nContributors:\n#{{CONTRIBUTORS}}",
          "max_pull_requests": 1000,
          "max_back_track_time_days": 1000
      }
    owner: ${{ github.repository_owner }}
    repo: ${{ github.event.repository.name }}
    toTag: ${{ env.TAG_NAME }}
    token: ${{ secrets.GITHUB_TOKEN }}
```

#### Explanation (1)

- **Categories:** Defines the sections in the changelog, each with a title and
associated labels. Pull requests are grouped under these sections based on
their labels.
- **User stories:** Includes pull requests labeled epic.
- **New features:** Includes pull requests labeled feature.
- **Bug fixes:** Includes pull requests labeled bug.
- **Documentation:** Includes pull requests labeled documentation.
- **Other Changes:** Includes pull requests labeled with any other labels.
- **template:** Defines the format of the changelog.
- **max_pull_requests:** The maximum number of pull requests to include in the
changelog.
- **max_back_track_time_days:** The maximum number of days to look back for
pull requests.

When the workflow is triggered, this step compares the previous tag with the new
tag and generates a changelog for all pull requests merged between the two tags.
Each pull request is added to the appropriate section based on its labels.

### Usage (1)

To use this workflow, call it from another workflow or manually with the
required inputs. For example:

```yaml
jobs:
  call-release-workflow:
    uses: your-repo/.github/workflows/create-release.yml
    with:
      artifact-name: my-artifact
      registry: ghcr.io/my-org
```

Ensure that a tag is pushed to the repository to trigger the release creation.

## Workflow (2): Pull Request Labeler

### Purpose (2)

This workflow automatically labels pull requests based on their branch name or
modified files. It uses a configuration file to determine the labels to apply.

### Trigger (2)

The workflow is triggered manually via workflow_call.

### Steps (2)

- Checkout Repository: Checks out the repository containing the `labeler.yml`
configuration file.
- Label Pull Request: Uses the `actions/labeler` action to apply labels to
the pull request based on the configuration.

### Configuration (2)

The labeler.yml file defines rules for labeling pull requests:

```yaml
documentation:
  - any:
    - changed-files:
      - any-glob-to-any-file:
        - 'docs/**'
        - '**/*.md'

tests:
  - any:
    - changed-files:
      - any-glob-to-any-file: tests/**

feature:
  - head-branch: ['^feature', 'feature', '^feat', 'feat']

bug:
  - head-branch: ['^bug', 'bug', '^fix', 'fix']

epic:
  - head-branch: ['^epic', 'epic']
```

### Usage (2)

- A pull request with the branch name `feature/new-feature` will be labeled as
**feature**.
- A pull request that modifies files in the `docs/` directory will be labeled as
**documentation**.
- A pull request with the branch name `bug/fix-issue` will be labeled as
**bug**.
- A pull request with the branch name `epic/new-epic` will be labeled as
**epic**.

By using these workflows, you can streamline the process of managing releases
and labeling pull requests in your repository.
