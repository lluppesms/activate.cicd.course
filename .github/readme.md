# GitHub Actions Deploy

This folder has a GitHub Action workflow that will build and deploy a Bicep file.

## Steps to Deploy App to Azure

- [Create the Repository Secrets](/.github/CreateGitHubSecrets.md)
- Edit the [/.github/workflows/run-az-command.yml](workflows/run-az-command.yml) in use an az command to deploy infrastructure
- Edit the [/.github/workflows/deploy-bicep.yml](workflows/deploy-bicep.yml) to use a templates and tasks to to deploy a bicep file and scan the templates.

Both of these actions can be edited to run automatically on any check-in or to run on demand.
