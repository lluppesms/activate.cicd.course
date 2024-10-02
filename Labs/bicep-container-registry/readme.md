# Bicep Container Registries

![hero](./img/Hero.png)

Modules are a great way to decompose your Bicep templates into smaller chunks of reusable code. This will simplify your code and make it easier to maintain and reuse, while allowing you to stitch resources together in a more modular way to deploy complex solutions. Modules will allow for both local and remote references and also facilitate version referencing.

## Contents

* [1. Bicep Modules](#step-1-bicep-modules)
* [2. Configuration](#step-2-configuration-and-security)
* [3. Create a Repository](#step-3-create-a-repository)
* [4. Helpful Scripts](#helpful-bicep-container-registry-commands)
* [5. References](#references)

---

## Step 1. Bicep Modules

There are three ways to reference modules

* Modules can be stored in the local repository and [referenced directly](#11-local-modules) in another main.bicep file.
* Modules can be referenced from a [`public` remote repository](#12-public-modules).
* Modules can be stored in a [`private` container registry](#13-private-modules) and referenced from there.

### 1.1 Local Modules

To reference a local module, you can use the following syntax:

``` bicep
module servicebusModule 'bicep/website.bicep' = { ...
```

For an example of that in action, see the [main-web-app.bicep](/main.bicep-Examples/local/main-web-app.bicep) file in this project.

To reference either a public module or a private module, you use the following syntax:

``` bicep
module servicebusModule 'br/<registryAlias>/<moduleName>:<moduleTag>' = { ...
```

### 1.2 Public Modules

Microsoft maintains a large public Bicep repository with a lot of comprehensive modules.  Check it out at [https://github.com/Azure/bicep-registry-modules/tree/main/avm/res](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res). These are a great source of info as you begin to build your own modules.

The registry alias `public:avm` is predefined in the VS Code Bicep environment, so you can reference modules like this with no additional configuration in your bicepconfig.json file by just starting with `br/public:avm`, like this:

``` bicep
module servicebusModule 'br/public:avm/res/operational-insights/workspace:0.6.0' = { ...
```

For an example of using public modules, see the [main-app-insights-public.bicep](/main.bicep-Examples/public/main-app-insights-public.bicep) file in this project.

### 1.3 Private Modules

This particular repository is focused on showing how to create and use modules stored in a PRIVATE container registry. This is a great way to store and share modules within your organization.

To reference a bicep file in a private container registry, the syntax changes slightly to:

``` bash
module servicebusModule 'br/<yourRegistryAlias>:<moduleName>:<tag>' = {
```

Note: For a private registry, the `yourRegistryAlias` in front of the module name must be defined in the bicep.config file as defined below.  The 'tag' can be an explicit value or something pre-defined like `LATEST`, all depending on how you deploy your modules.

---

## Step 2. Configuration and Security

### 2.1 bicep.config file

A bicep.config file will need to be added to a project that refers to the registry defining the location of the registry, like this:

``` base
{
    "moduleAliases": {
        "br": {
            "<yourRegistryAlias>": {
                "registry": "<yourRegistryName>.azurecr.io",
                "modulePath": "bicep"
            }
        }
    }
}
```

* `yourRegistryAlias` can be anything, but whatever is in the bicepconfig.json file has to match what you use in the main.bicep file. Try to keep this name fairly generic and not and a tightly-coupled exact match to the registry name.
* `yourRegistryName` is the name of the container registry which has been published in Azure and must be globally unique
* `modulePath` value is defined when the Bicep file is published into the registry.

### 2.2 Security

In order for the pipeline to access the bicep container registry, the service principal will need to be in the `acrpull` role for the container registry.  In this example repository, the service principal is granted `acrpush` (which includes acrpull) as part of the [containerregistry.bicep](bicep/containerregistry.bicep) deployment, as deployed in the [create-bicep-registry.yml](./azdo/pipelines/create-bicep-container-registry.yml) pipeline.

### 2.3 Warning - Don't use these Bicep Files in Production!

WARNING: The bicep files in this repository are for demonstration purposes only.  They are not intended for production use and may contain errors or security vulnerabilities. In fact, they intentionally contain some vulnerabilities so you can see them in the scan portion of the pipeline job.

> **By using this code, you acknowledge that you are using this repository and it's code at your own risk, and you MUST review and test all code before using it in a production environment. By using this code, you are assuming responsibility to perform those reviews.**

---

## Step 3. Create a Repository

### 3.1: Setup a Bicep Container Registry

Register and run the pipeline [create-bicep-registry.yml](./pipelines/create-bicep-container-registry.yml) to create the initial registry. To run, this pipeline needs five variables defined on the pipeline definition: serviceConnectionName, registryName, resourceGroupName, location, and servicePrincipalObjectId.

Alternatively, you could run a command similar to the one below to create a container registry in a resource group manually.

``` bash
$resourceGroupName = 'yourResourceGroup'
$registryName = 'yourRegistryName'
$servicePrincipalObjectId = 'yourGuid'
az deployment group create `
 --resource-group $resourceGroupName `
 --template-file 'bicep/containerregistry.bicep' `
 --parameters registryName=$registryName servicePrincipalObjectId=$servicePrincipalObjectId

```

### 3.2: Publish Bicep Files into the Container Registry

You can publish Bicep files into the container registry manually or automatically whenever files change.

#### 3.2a: Manual Publish

When you want to manually publish a new Bicep file into the registry, you can run a command similar to the one below. This will push the bicep file into the registry with the module path and version defined. However, doing this manually can be rather tedious.

``` bash
$registryName="yourBicepRegistryName"
$modulePath="bicep"
$modulePath="yourNewModule"
$moduleVersion="v1.0.0"
$delimiter=":"
az bicep publish `
  --file yourNewModule.bicep `
  --target br:$registryName.azurecr.io/$modulePath/$modulePath$delimiter$moduleVersion

```

#### 3.2b: Automated Publish

Alternatively, you can set up a pipeline that will push automatically publish any bicep file changes to the container registry whenever they are committed to the Bicep folder.

The [publish-bicep-modules-to-registry.yml](./pipelines/publish-bicep-modules-to-registry.yml) is set up to do exactly that using a [PowerShell script](./pipelines/templates/template-publish-bicep.yml) . Once it's set up, it will trigger whenever you check code into the main branch of your repository. The pipeline needs two variables defined when you register it: registryName and serviceConnectionName.

This pipeline also optionally employs the [Microsoft Secure DevOps Scan](https://marketplace.visualstudio.com/items?itemName=ms-securitydevops.microsoft-security-devops-azdevops) extension, which must be installed in your Azure DevOps Organization before running the pipeline. This extension will scan the Bicep code for security vulnerabilities and provide a report.

---

## Helpful Bicep Container Registry Commands

See the [scripts.md](scripts.md) file for a variety of PowerShell commands that will allow you to interact directly with the container registry, including listing and deleting images.

---

## References

* [Bicep Container Registries](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry)
* [Azure Container Registries (general)](https://learn.microsoft.com/en-us/azure/container-registry/)
* [Azure Verified Modules](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res)
* [Bicep Syntax Examples](https://github.com/azure/azure-docs-bicep-samples)

Older Example References:

* [Azure Quickstart Templates](https://aka.ms/azqst)
* [Resource Modules – CARML](https://github.com/azure/resourceModules)
* [Bicep Sample Modules](https://github.com/Azure/azure-quickstart-templates/tree/master/demos)
