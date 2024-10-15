# Activate CICD with Azure DevOps Using YML and Bicep

## Prerequisites

You will need an Azure DevOps Organization and Project in order to complete this workshop. If you don't already have an Azure DevOps Organization, you can create one for free at [dev.azure.com](http://dev.azure.com). You will also need an Azure Subscription to deploy resources to Azure.  For more detailed information on setting an organization and project, see the [Create an Azure DevOps Project](../setup/1-Create-Azdo-Project.md) document for more information.

Once we proceed to the Bicep part of the course, you will also want an editor like VS Code to edit the YML and Bicep files, and a few key extensions to make things better. See the [Visual Studio Code Setup](../setup//3-Visual-Studio-Code.md) document for more information.

If you have not created your own repository for the class based on the course materials, please follow the instructions in the [Import the Class Repository](../setup/3-Clone-Repo.md) guide.

If you need a Build Agent for this class for some reason, you can refer to the [Creating a Custom Build Agent](../build-agents/desktop-runner/readme.md) document to assist you in creating it. You can use the default of the Microsoft Hosted Agents, but if you have a large class it may be better to each have your own custom custom agent.

## YML Labs

This workshop will cover a series of labs, in which you will learn to create effective YML pipelines.

### Before You Start

* [Lab 0.1 - Setting up an Azure DevOps Project](../setup/1-Create-Azdo-Project.md)
* [Lab 0.2 - Tooling with Visual Studio Code](../setup/3-Visual-Studio-Code.md)
* [Lab 0.3 - Import the Class Repository](../setup/3-Clone-Repo.md)
* [Lab 0.4 - Creating a Custom Build Agent (optional)](../build-agents/desktop-runner/readme.md)

### Introduction To Pipelines

* [Lab 1 - Introduction](./01_Starter/readme.md)
  * [Create a YAML-Pipeline via GUI](./01_Starter/readme.md#exercise-11-create-a-yaml-pipeline-via-gui)
  * [Run your pipeline](./01_Starter/readme.md#exercise-12-run-your-pipeline)
  * [Analyze the output](./01_Starter/readme.md#exercise-13-analyze-the-output)
  * [Use the assistant to add tasks](./01_Starter/readme.md#exercise-14-use-the-assistant-to-add-tasks)
  * [Extend the pipeline with variables](./01_Starter/readme.md#exercise-15-extend-your-pipeline-with-variables)
  * [Check the pipeline within the repository](./01_Starter/readme.md#exercise-16-check-the-pipeline-within-your-repository)

### Tasks, Jobs, Stages and Dependencies
  
* [Lab 2 - Tasks, Jobs, Stages and Dependencies](./02_Stages/readme.md)
  * [Separating tasks into different jobs](./02_Stages/readme.md#exercise-21-separating-tasks-into-different-jobs)
  * [Adding dependencies between jobs](./02_Stages/readme.md#exercise-22-adding-dependencies-between-jobs)
  * [Splitting our pipeline into stages](./02_Stages/readme.md#exercise-23-splitting-our-pipeline-into-stages)
  * [Dependencies between stages](./02_Stages/readme.md#exercise-24-adding-dependencies-between-jobs-and-stages)
  * [Approvals](./02_Stages/readme.md#exercise-25-approvals)

### Working with Templates

* [Lab 3 - Working with Templates](./03_Templates/readme.md)
  * [Load steps from templates](./03_Templates/readme.md#exercise-31-load-steps-from-templates)
  * [Reusing stages with templates](./03_Templates/readme.md#exercise-32-reusing-stages-with-templates)
  * [Conditional Execution](./03_Templates/readme.md#exercise-33-conditions)
  * [Skipping stages](labs/lab3/lab3.md#exercise-34-skipping-stages)

### Triggers
  
* [Lab 4 - Triggers](./04_Triggers/readme.md)
  * [Working with triggers and branches](./04_Triggers/readme.md#exercise-4-1-working-with-triggers-and-branches)
  * [Working with triggers and paths](./04_Triggers/readme.md#exercise-42-working-with-triggers-and-path)
  * [Schedule Triggers](./04_Triggers/readme.md#exercise-43-scheduled-trigger)
  * [Pull Request Triggers](./04_Triggers/readme.md#exercise-44-pull-request-triggers)

### More Variables and Parameters

* [Lab 5 - More Variables and Parameters](./05_Variables/readme.md)
  * [5.1 Using Parameters](./05_Variables/readme.md#exercise-51-using-parameters)
  * [5.2 Using Local Variables](./05_Variables/readme.md#exercise-52-local-variables)
  * [5.3 Variable Template Files](./05_Variables/readme.md#exercise-53-variable-template-files)
  * [5.4 Predefined Variables](./05_Variables/readme.md#exercise-54-predefined-variables)
  * [5.5 Creating Variables in Code](./05_Variables/readme.md#exercise-55-creating-variables-in-code)
  * [5.6 Using Variable Groups](./05_Variables/readme.md#exercise-56-using-variable-groups)
  * [5.7 Loading Values from Key Vault](./05_Variables/readme.md#exercise-57-loading-values-from-key-vault)
  * [5.8 Verbose Logs](./05_Variables/readme.md#exercise-58-verbose-logs)

### Multiple Environments and Stages

* [Lab 6 - Multiple Environments and Stages](./06_Environments/readme.md)
  * [6.1 Creating AzDO Environments](./06_Environments/readme.md#exercise-61-creating-azdo-environments)
  * [6.2 Deploying to Multiple Environments with Dependencies](./06_Environments/readme.md#exercise-62-deploying-to-multiple-environments-with-dependencies)

### Reusable Libraries

* [Lab 7 - Reusable Libraries](./07_TemplateRepository/readme.md)
  * [7.1 Creating a Template Repository](./07_TemplateRepository/readme.md#exercise-71-creating-a-template-repository)

### Using Resources - Splitting CI and CD

* [Lab 8 - Splitting CI and CD](./08_Split_CI_CD/readme.md)
  * [Creating a Build pipeline and saving the artifacts](./08_Split_CI_CD/readme.md#exercise-81-build-pipelines-and-artifacts)
  * [Creating a Release Pipeline using a pre-built artifact](./08_Split_CI_CD/readme.md#exercise-82-working-with-build-artifacts)

---

[Table of Contents](../../readme.md)