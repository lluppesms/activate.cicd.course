# ------------------------------------------------------------------------------------
# Create a Azure Devops Build Runner in Azure Container Apps - Step 1
# ------------------------------------------------------------------------------------
# Reference: 
#   https://learn.microsoft.com/en-us/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-azure-pipelines
# ------------------------------------------------------------------------------------
# Steps:
#   1. Create a PAT Token in Azure DevOps with Agent Pool read/write permissions.
#   2. Create an Agent Pool in Azure DevOps
#   3. Run 1_create_aca_environment.ps1 with your Unique Id to create the ACA environment and ACR registry.
#   4. Run 2_create_containerapp_job.ps1 with your Unique Id and OrgName and Token to create the job.
# ------------------------------------------------------------------------------------
# Note: 
#   This solution using ACA does not support Windows Container Images
#   Also - the example Linux Container Image only provides basic tools like CURL
#      So -- you may need to create your own DockerFile with the proper tools
# ------------------------------------------------------------------------------------
# You may need to run this first in PowerShell...
#   Connect-AzAccount
# ------------------------------------------------------------------------------------
# Run with only required parameters:
# ./1_create_aca_environment.ps1 -UniqueId 'xxx'
# ------------------------------------------------------------------------------------
# Run with all parameters:
# ./1_create_aca_environment.ps1 `
# -UniqueId 'xxx' `
# -ResourceGroupName 'rg_aca_agent' `
# -Location 'northcentralus' `
# -ManagedIdentitySuffix 'aca-agent-mi' `
# -ContainerAppsEnvSuffix 'aca-agent-env' `
# -ContainerRegistrySuffix 'acaagentacr' `
# -ContainerImageSuffix 'azure-pipelines-ubuntu-agent:1.0' `
# -DockerFile = "Dockerfile.ubuntu-aca-agent" `
# ------------------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $true)] [string] $UniqueId,
    [Parameter()] [string] $ResourceGroupName = 'rg_aca_build_agent',
    [Parameter()] [string] $Location = 'eastus',
    [Parameter()] [string] $ManagedIdentitySuffix = 'aca-agent-mi',
    [Parameter()] [string] $ContainerAppsEnvSuffix  = 'aca-agent-env',
    [Parameter()] [string] $ContainerRegistrySuffix  = 'acaagentacr',
    [Parameter()] [string] $ContainerImageSuffix = 'azure-pipelines-ubuntu-agent:1.0',
    [Parameter()] [string] $DockerFile = "Dockerfile.ubuntu-aca-agent"
)

$ManagedIdentityResourceName = $UniqueId + '-' + $ManagedIdentitySuffix
$ContainerRegistryName = $UniqueId + $ContainerRegistrySuffix
$ContainerAppsEnvName = $UniqueId + '-' + $ContainerAppsEnvSuffix
$ContainerImageName = $UniqueId + '-' + $ContainerImageSuffix
$DockerFilePath = "../docker/" + $DockerFile

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Starting ACA Build Agent - ACR and Container App deploy with the following parameters:" -ForegroundColor Yellow
Write-Host "** ResourceGroupName: $ResourceGroupName" -ForegroundColor Yellow
Write-Host "** Location: $Location" -ForegroundColor Yellow
Write-Host "** DockerFile: $DockerFile" -ForegroundColor Yellow
Write-Host "** ContainerAppsEnvName: $ContainerAppsEnvName" -ForegroundColor Yellow
Write-Host "** ContainerRegistryName: $ContainerRegistryName" -ForegroundColor Yellow
Write-Host "** ContainerImageName: $ContainerImageName" -ForegroundColor Yellow
Write-Host "** ManagedIdentityResourceName: $ManagedIdentityResourceName" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "`n"

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating Resource Group $ResourceGroupName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az group create --name $ResourceGroupName --location $LOCATION

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating Log Analytics Workspace $WorkspaceName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
$WorkspaceName = $ContainerAppsEnvName+"-la"
az monitor log-analytics workspace create `
    --resource-group $ResourceGroupName `
    --workspace-name $WorkspaceName `
    --location $Location

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Getting Log Analytics Workspace ID..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
$workspace = az monitor log-analytics workspace show `
    --resource-group $ResourceGroupName `
    --workspace-name $WorkspaceName `
    --query "{workspaceId: customerId, workspaceKey: primaryKey}" `
    --output json | ConvertFrom-Json
$LogWorkspaceId = $workspace.workspaceId
Write-Host "   LogWorkspaceId: $LogWorkspaceId" -ForegroundColor Green

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating Container App Environment $ContainerAppsEnvName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az containerapp env create `
    --name $ContainerAppsEnvName `
    --resource-group $ResourceGroupName `
    --location $LOCATION `
    --logs-workspace-id $LogWorkspaceId
# $containerapp = az containerapp env show --name $ContainerAppsEnvName --resource-group $ResourceGroupName
# Write-Host "   containerapp.id: $containerapp.id" -ForegroundColor Green
Write-Host "`n"
    
Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating Container Registry $ContainerRegistryName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az acr create `
    --name $ContainerRegistryName `
    --resource-group $ResourceGroupName `
    --location $LOCATION `
    --sku Basic `
    --admin-enabled true
Write-Host "`n"
    
Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating Managed Identity $ManagedIdentityResourceName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
$managedIdentity = az identity create --name $ManagedIdentityResourceName --resource-group $ResourceGroupName
Write-Host "   managedIdentity.id: $managedIdentity.id" -ForegroundColor Green
Write-Host "`n"

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Adding ACR Pull permissions to ACR for Managed Identity..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az role assignment create `
    --assignee-object-id $(az identity show --name $ManagedIdentityResourceName --resource-group $ResourceGroupName --query principalId -o tsv) `
    --role acrpull `
    --scope $(az acr show --name $ContainerRegistryName --resource-group $ResourceGroupName --query id -o tsv)


Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
if (-not (Test-Path -Path $DockerFile)) {
    Write-Host '$(Get-Date -Format HH:mm:ss) - The Ubuntu DockerFile does not exist!' -ForegroundColor Red
    throw 'The Ubuntu DockerFile does not exist!'
} 

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Building ACR Ubuntu Build Server Image from $DockerFilePath to $ContainerImageName..."
Write-Host "   az acr build --registry $ContainerRegistryName --image $ContainerImageName --file $DockerFile ."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az acr build `
    --registry $ContainerRegistryName `
    --image $ContainerImageName `
    --file $DockerFile .

Write-Host "`n"
Write-Host "** $(Get-Date -Format HH:mm:ss) - ACR Setup job setup complete." -ForegroundColor Green
Write-Host "** Run Step 2 to complete setup!" -ForegroundColor Green
Write-Host "`n"
