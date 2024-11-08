# GitHub Actions Deploy

This folder has a GitHub Action workflows that will build and deploy a Bicep file.

## Steps to Deploy App to Azure

- [Create the Repository Secrets](/.github/CreateGitHubSecrets.md)
- Edit the [/.github/workflows/labs-run-az-command.yml](workflows/labs-run-az-command.yml) in use an az command to deploy infrastructure
- Edit the [/.github/workflows/labs-deploy-bicep.yml](workflows/labs-deploy-bicep.yml) to use a templates and tasks to to deploy a bicep file and scan the templates.

Both of these actions can easily be edited to run automatically on any check-in or to just run on demand when you request it.

---

[Home Page](./README.md)
