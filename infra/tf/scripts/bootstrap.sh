#!/bin/bash
# Outside of this file, you should have the follow TF ENV VARS already set on your local workstation
# export ARM_CLIENT_ID=<your-client-id>
# export ARM_CLIENT_SECRET=<your-client-secret>
# export ARM_SUBSCRIPTION_ID=<your-subscription-id>
# export ARM_TENANT_ID=<your-tenant-id>

# Update these env vars to match desired names in your Azure Subscription
export STATE_FILE_RG=ado-tfstate-rg
export STATE_FILE_SA=satfstate23509
export STATE_FILE_CONTAINER=tfstate
export STATE_FILE_LOCATION=eastus2

if az storage account show --resource-group $STATE_FILE_RG --name $STATE_FILE_SA --query "provisioningState" -o tsv; then
                echo "Storage Account already exists"
            else
                echo "Creating new Storage Account"
                az group create --name $STATE_FILE_RG --location $STATE_FILE_LOCATION
                az storage account create --resource-group $STATE_FILE_RG --name $STATE_FILE_SA --sku Standard_LRS --encryption-services blob
                tfBackendStorageKey=$(az storage account keys list --account-name $STATE_FILE_SA --resource-group $STATE_FILE_RG --query "[0].value" --output tsv)
                az storage container create --name $STATE_FILE_CONTAINER --public-access off --account-name $STATE_FILE_SA --account-key $tfBackendStorageKey
                az storage account update --allow-shared-key-access true --name $STATE_FILE_SA --resource-group $STATE_FILE_RG
            fi