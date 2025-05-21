# Lab 1: Terraform AzureRM Provider

## References

[Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[Terraform TFVars](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables)
[Terraform Azure Provider Authentication Options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## Pre-Requisites

- [ ] Powershell or Bash installed locally
- [ ] Visual Studio Code
- [ ] An Azure Subscription with Owner Permissions
- [ ] Install Terraform CLI
- [ ] Clone the Repository to your Local Machine
- [ ] Create an Azure Service Principal

  ``` bash
  az ad sp create-for-rbac --name "TerraformServicePrincipal" --role Contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID --output json
  ```

- [ ] Copy the output of the above command and save it in a secure location. The output will look like this:

  ```json
  {
    "appId": "YOUR_CLIENT_ID",
    "displayName": "TerraformServicePrincipal",
    "name": "http://TerraformServicePrincipal",
    "client_secret": "YOUR_CLIENT_SECRET",
    "tenant": "YOUR_TENANT_ID"
  }
  ```

- [ ] Install Azure CLI

  ``` bash
  # log in to CLI: 
  az login --service-principal --username APP_ID --password CLIENT_SECRET --tenant TENANT_ID

  # set azure subscription
  az account set <subscription_id>

  #confirm subscription
  az account show --output table
  ```

- [ ] Assign the Service Principal with Contributor role to the subscription
- [ ] Export the following Environment Variables for Terraform to run locally using the Service Principal against your Azure Subscription

- Bash Commands to set environment variables:

  ``` bash
  export ARM_SUBSCRIPTION_ID=<YOUR_SUBSCRIPTION_ID>
  export ARM_TENANT_ID=<YOUR_TENANT_ID>
  export ARM_CLIENT_ID=<YOUR_CLIENT_ID>
  export ARM_CLIENT_SECRET=<YOUR_CLIENT_SECRET>
  ```

- PowerShell Commands to set environment variables:

  ``` powershell
  $env:ARM_SUBSCRIPTION_ID="<YOUR_SUBSCRIPTION_ID>"
  $env:ARM_TENANT_ID="<YOUR_TENANT_ID>"
  $env:ARM_CLIENT_ID="<YOUR_CLIENT_ID>"
  $env:ARM_CLIENT_SECRET="<YOUR_CLIENT_SECRET>"
  ```

---

## Lab 1: Run Terraform Locally and create resources in Azure

1. Make sure you are in the scripts directory. Run a ```terraform init``` command to initialize the Terraform working directory. This command downloads the necessary provider plugins and sets up the backend configuration.

    Note how a .terraform directory is created in the scripts directory. This is where terraform stores the provider plugins and other necessary files.

2. Next let's run a terraform plan to see what will happen if our code were to be applied to an Azure Subscription.

    **Important** Ensure you are in the ```scripts``` folder when running this command otherwise it will not pick up your tfvars files.

    ``` bash
    terraform plan -var-file=../config/dev-poc/applicationinsights.auto.tfvars  -var-file=../config/dev-poc/appserviceplan.auto.tfvars -var-file=../config/dev-poc/parameters.auto.tfvars -var-file=../config/dev-poc/resourcegroups.auto.tfvars -out=tfplan
    ```

3. Review the output of the terraform plan command. Your output should look very similar to this:

    ``` yml
    Terraform will perform the following actions:

      # azurerm_service_plan.example will be created
      + resource "azurerm_service_plan" "example" {
          + id                           = (known after apply)
          + kind                         = (known after apply)
          + location                     = "westeurope"
          + maximum_elastic_worker_count = (known after apply)
          + name                         = "asptoday1234-dev"
          + os_type                      = "Linux"
          + per_site_scaling_enabled     = false
          + reserved                     = (known after apply)
          + resource_group_name          = "asp-dev-rg"
          + sku_name                     = "F1"
          + worker_count                 = (known after apply)
        }

      # module.app_insights.data.azurerm_resource_group.this will be read during apply
      # (depends on a resource or a module with changes pending)
    <= data "azurerm_resource_group" "this" {
          + id       = (known after apply)
          + location = (known after apply)
          + name     = "asp-dev-rg"
          + tags     = (known after apply)
        }

      # module.app_insights.azurerm_application_insights.this["appinsight1"] will be created
      + resource "azurerm_application_insights" "this" {
          + app_id                                = (known after apply)
          + application_type                      = "web"
          + connection_string                     = (sensitive value)
          + daily_data_cap_in_gb                  = (known after apply)
          + daily_data_cap_notifications_disabled = (known after apply)
          + disable_ip_masking                    = false
          + force_customer_storage_for_profiler   = false
          + id                                    = (known after apply)
          + instrumentation_key                   = (sensitive value)
          + internet_ingestion_enabled            = true
          + internet_query_enabled                = true
          + local_authentication_disabled         = false
          + location                              = (known after apply)
          + name                                  = "application-insights-dev"
          + resource_group_name                   = "asp-dev-rg"
          + retention_in_days                     = 60
          + sampling_percentage                   = 100
          + tags                                  = (known after apply)
        }

      # module.resource_groups.azurerm_resource_group.this["resource_group_1"] will be created
      + resource "azurerm_resource_group" "this" {
          + id       = (known after apply)
          + location = "westeurope"
          + name     = "asp-dev-rg"
          + tags     = {
              + "app_id"     = "00000"
              + "contact_dl" = "codycarlson@microsoft.com"
              + "created_by" = "codycarlson"
            }
        }

    Plan: 3 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
      + application_insights = (sensitive value)
      + resource_groups      = {
          + resource_group_ids_map       = {
              + asp-dev-rg = (known after apply)
            }
          + resource_group_locations_map = {
              + asp-dev-rg = "westeurope"
            }
          + resource_group_tags_map      = {
              + asp-dev-rg = {
                  + "app_id"     = "00000"
                  + "contact_dl" = "codycarlson@microsoft.com"
                  + "created_by" = "codycarlson"
                }
            }
        }
    ```

4. After reviewing the tfplan output and ensure it matches desired configuration changes, run the command ```terraform apply tfplan``` from the scripts folder to apply the changes created by the previous tfplan

5. Confirm successful run and verify changes in your Azure Portal

---

At this point, we have successfully connected to Azure and deployed a resource using a Terraform template! This completes this lab.

[Next Lab](./lab02.md) | [Table of Contents](../../readme.md)
