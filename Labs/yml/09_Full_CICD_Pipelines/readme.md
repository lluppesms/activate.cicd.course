# Example Pipelines to Automate Deployments

## Examples

In this lab, we will see examples in ascending order, building on the concepts outlined in the course for each pipeline.

| File | Description |
| -- | -- |
| 01-simplest-pipeline | The simplest YML file example with hard-coded values |
| 02-pipeline-with-parms | This YML file uses user parameters to deploy resources |
| 03-pipeline-with-variable-file | This pipeline shows how to put variables in a YML var file |
| 04-pipeline-with-bicep-parm-file | This pipeline shows how to use a Bicep Parameter file so that your YML is not hard-coded with variable names |
| 05-pipeline-merging-variable-file-and-bicep-parm-file | This pipeline shows how to merge variables into a Bicep Parameter File |
| 06-pipeline-with-template | This pipeline pulls out the code in pipeline 05 and creates a reusable template for deploying resources |
| 07-pipeline-with-scanning-template | This pipeline adds in a code scanning template |
| 08-pipeline-build-deploy-app | This pipeline uses all of the above concepts, then adds in a build and deploy template to deploy a live app |
| 09-pipeline-build-deploy-app | This pipeline shows how to deploy to multiple stages (i.e. DEV/QA/PROD)  |
| 10-pipeline-build-deploy-test-app | This pipeline shows how to deploy to multiple stages and run smoke tests  |

| 91-example-scan-pipeline | This pipeline executes a security scan on a scheduled basis. |
| 92-example-pr-pipeline | This pipeline gets kicked off whenever a PR is submitted as part of the PR |
| 93-example-library-pipeline | This pipeline shows how to use external templates from another repository |
| 94-example-deploy-dependency-pipeline | This pipeline shows how to use dependencies between stages |
| 95-example-compile-sign-kv-pipeline | This pipeline compiles a SFE (single-file-executable) and signs it with a Cert from a Key Vault |
| 96-example-auto-test-pipeline | This pipeline is a automated test that gets auto-triggered when another pipeline finishes. |
| 97-example-cross-job-variables | This pipeline creates variables that can be passed across jobs, in a deployment or not in a deployment. |
| 98-example-multiple-service-connections | This pipeline shows how to multiple service connections - one for DEV/QA/PROD |

For more info on setting up pipelines and environments, see:

- [Create Azure DevOps Service Connections](./CreateServiceConnections.md)
- [Create Azure DevOps Environments](./CreateDevOpsEnvironments.md)
- [Create Azure DevOps Variable Groups](./CreateDevOpsVariableGroups.md)
- [Create New Pipelines](./CreateNewPipeline.md)

## Additional Microsoft Learn Labs

1. Deploy Azure resources by using Bicep and Azure Pipelines - [https://learn.microsoft.com/en-au/training/modules/build-first-bicep-deployment-pipeline-using-azure-pipelines/](https://learn.microsoft.com/en-au/training/modules/build-first-bicep-deployment-pipeline-using-azure-pipelines/)

2. Deploy Azure resources by using Bicep and GitHub Actions - [https://learn.microsoft.com/en-au/training/modules/build-first-bicep-deployment-pipeline-using-github-actions/](https://learn.microsoft.com/en-au/training/modules/build-first-bicep-deployment-pipeline-using-github-actions/)

