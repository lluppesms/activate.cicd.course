# Activate CICD with Azure DevOps Using YML and Bicep

## Getting Started

You will need an Azure DevOps Organization and Project in order to complete this workshop. If you don't already have an Azure DevOps Organization, you can create one for free at [dev.azure.com](http://dev.azure.com). You will also need an Azure Subscription to deploy resources to Azure.  For more detailed information on setting an organization and project, see the [Create an Azure DevOps Project](/Labs/lab0/Create-Azdo-Project.md) document for more information.

Once we proceed to the Bicep part of the course, you will also want an editor like VS Code to edit the YML and Bicep files, and a few key extensions to make things better. See the [Visual Studio Code Setup](/Labs/lab0/Visual-Studio-Code.md) document for more information.

If you need a Build Agent for this class, you can refer to the [Creating a Custom Build Agent](/Labs/Build-Agents/desktop-runner/readme.md) document to assist you in creating it. You can use the default of the Microsoft Hosted Agents, but if you have a large class it may be better to each have your own custom custom agent.

## YML Labs

This workshop will cover a series of labs, in which you will learn to create effective YML pipelines.

<details>
  <summary>Before You Start...</summary>

* [Lab 0.1 - Create an Azure DevOps Project](../setup/Create-Azdo-Project.md)
* [Lab 0.2 - Create a Custom Build Agent](../build-agents/desktop-runner/readme.md)
* [Lab 0.3 - Set up Visual Studio Code (Optional)](../setup//Visual-Studio-Code.md)

</details>

<details>
  <summary>Lab 1 - Introduction To Pipelines</summary>

* [Lab 1 - Introduction](./01_Starter/readme.md)
  * [Create a YAML-Pipeline via GUI](./01_Starter/readme.md#exercise-11-create-a-yaml-pipeline-via-gui)
  * [Run your pipeline](./01_Starter/readme.md#exercise-12-run-your-pipeline)
  * [Analyze the output](./01_Starter/readme.md#exercise-13-analyze-the-output)
  * [Use the assistant to add tasks](./01_Starter/readme.md#exercise-14-use-the-assistant-to-add-tasks)
  * [Extend the pipeline with variables](./01_Starter/readme.md#exercise-15-extend-your-pipeline-with-variables)
  * [Check the pipeline within the repository](./01_Starter/readme.md#exercise-16-check-the-pipeline-within-your-repository)

</details>

<details>
  <summary>Lab 2 - Tasks, Jobs, Stages and Dependencies</summary>
  
* [Lab 2 - Tasks, Jobs, Stages and Dependencies](./02_Stages/readme.md)
  * [Separating tasks into different jobs](./02_Stages/readme.md#exercise-21-separating-tasks-into-different-jobs)
  * [Adding dependencies between jobs](./02_Stages/readme.md#exercise-22-adding-dependencies-between-jobs)
  * [Splitting our pipeline into stages](./02_Stages/readme.md#exercise-23-splitting-our-pipeline-into-stages)
  * [Dependencies between stages](./02_Stages/readme.md#exercise-24-adding-dependencies-between-jobs-and-stages)
  * [Approvals](./02_Stages/readme.md#exercise-25-approvals)

</details>

<details>
  <summary>Lab 3 - Working with Templates</summary>

* [Lab 3 - Working with Templates](./03_Templates/readme.md)
  * [Load steps from templates](./03_Templates/readme.md#exercise-31-load-steps-from-templates)
  * [Reusing stages with templates](./03_Templates/readme.md#exercise-32-reusing-stages-with-templates)
  * [Conditional Execution](./03_Templates/readme.md#exercise-33-conditions)
  * [Skipping stages](labs/lab3/lab3.md#exercise-34-skipping-stages)

</details>

<details>
  <summary>Lab 4 - Triggers</summary>
  
* [Lab 4 - Triggers](./04_Triggers/readme.md)
  * [Working with triggers and branches](./04_Triggers/readme.md#exercise-4-1-working-with-triggers-and-branches)
  * [Working with triggers and paths](./04_Triggers/readme.md#exercise-42-working-with-triggers-and-path)
  * [Schedule Triggers](./04_Triggers/readme.md#exercise-43-scheduled-trigger)
  * [Pull Request Triggers](./04_Triggers/readme.md#exercise-44-pull-request-triggers)

</details>

<details>
  <summary>Lab 5 - More Variables and Parameters</summary>

* [Lab 5 - More Variables and Parameters](./05_Variables/readme.md)
  * [5.1 Using Parameters](./05_Variables/readme.md#exercise-51-using-parameters)
  * [5.2 Using Local Variables](./05_Variables/readme.md#exercise-52-local-variables)
  * [5.3 Variable Template Files](./05_Variables/readme.md#exercise-53-variable-template-files)
  * [5.4 Predefined Variables](./05_Variables/readme.md#exercise-54-predefined-variables)
  * [5.5 Creating Variables in Code](./05_Variables/readme.md#exercise-55-creating-variables-in-code)
  * [5.6 Using Variable Groups](./05_Variables/readme.md#exercise-56-using-variable-groups)
  * [5.7 Loading Values from Key Vault](./05_Variables/readme.md#exercise-57-loading-values-from-key-vault)
  * [5.8 Verbose Logs](./05_Variables/readme.md#exercise-58-verbose-logs)

</details>

<details>
  <summary>Lab 6 - Multiple Environments and Stages</summary>

* [Lab 6 - Multiple Environments and Stages](./06_Environments/readme.md)
  * [6.1 Creating AzDO Environments](./06_Environments/readme.md#exercise-61-creating-azdo-environments)
  * [6.2 Deploying to Multiple Environments with Dependencies](./06_Environments/readme.md#exercise-62-deploying-to-multiple-environments-with-dependencies)

</details>

<details>
  <summary>Lab 7 - Reusable Libraries</summary>

* [Lab 7 - Reusable Libraries](./07_TemplateRepository/readme.md)
  * [7.1 Creating a Template Repository](./07_TemplateRepository/readme.md#exercise-71-creating-a-template-repository)

</details>

<details>
  <summary>Lab 8 - Using Resources - Splitting CI and CD</summary>

* [Lab 8 - Splitting CI and CD](./08_CICD/readme.md)
  * [Creating a Build pipeline and saving the artifacts](./08_CICD/readme.md#exercise-81-build-pipelines-and-artifacts)
  * [Creating a Release Pipeline using a pre-built artifact](./08_CICD/readme.md#exercise-82-working-with-build-artifacts)

</details>
