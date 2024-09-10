# ------------------------------------------------------------------------------------
# Create a Azure Devops Build Runner in Azure Container Apps - Step 2
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
# ./2_create_containerapp_job.ps1 -UniqueId 'xxx' -OrgName 'mycompany' -PatToken ''
# ------------------------------------------------------------------------------------
# Run with all parameters:
# ./2_create_containerapp_job.ps1 `
#  -OrgName 'mycompany' `
#  -PatToken '' `
#  -ResourceGroupName 'rg_aca_agent' `
#  -AzdoAgentPoolName 'ubuntu_aca' `
#  -ManagedIdentitySuffix 'aca-agent-mi'
#  -ContainerAppsEnvSuffix 'aca-agent-env' `
#  -ContainerRegistrySuffix 'acaagentacr' `
#  -ContainerImageSuffix = 'azure-pipelines-ubuntu-agent:1.0' `
#  -PlaceholderSuffix 'placeholder-agent-job' `
#  -JobSuffix 'azure-pipelines-agent-job' `
#  -MaxJobs 5 `
#  -PollingIntervalSeconds 10
# ------------------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $true)] [string] $UniqueId,
    [Parameter(Mandatory = $true)] [string] $PatToken,
    [Parameter(Mandatory = $true)] [string] $OrgName,
    [Parameter()] [string] $ResourceGroupName = 'rg_aca_build_agent',
    [Parameter()] [string] $AzdoAgentPoolName = 'ubuntu_aca',
    [Parameter()] [string] $ManagedIdentitySuffix = 'aca-agent-mi',
    [Parameter()] [string] $ContainerAppsEnvSuffix  = 'aca-agent-env',
    [Parameter()] [string] $ContainerRegistrySuffix  = 'acaagentacr',
    [Parameter()] [string] $ContainerImageSuffix = 'azure-pipelines-ubuntu-agent:1.0',
    [Parameter()] [string] $PlaceholderSuffix = 'placeholder-agent-job',
    [Parameter()] [string] $JobSuffix = 'azure-pipelines-agent-job',
    [Parameter()] [string] $MaxJobs = 5, # Maximum number of jobs to run per polling interval
    [Parameter()] [string] $PollingIntervalSeconds = 10  # Interval to check each event source in seconds
)

$ErrorActionPreference = "Stop"

$AzdoOrgUrl = 'https://dev.azure.com/' + $OrgName # Make sure no trailing / is present at the end of the URL.
$ManagedIdentityResourceName = $UniqueId + '-' + $ManagedIdentitySuffix
$ContainerRegistryName = $UniqueId + $ContainerRegistrySuffix
$ContainerAppsEnvName = $UniqueId + '-' + $ContainerAppsEnvSuffix
$ContainerImageName = $UniqueId + '-' + $ContainerImageSuffix
$PlaceholderJobName = $UniqueId + '-' + $PlaceholderSuffix
$JobName = $UniqueId + '-' + $JobSuffix

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Starting ACA Build Agent - Container App Build with the following parameters:" -ForegroundColor Yellow
Write-Host "** ResourceGroupName: $ResourceGroupName" -ForegroundColor Yellow
Write-Host "** AzdoOrgUrl: $AzdoOrgUrl" -ForegroundColor Yellow
Write-Host "** PatToken: $PatToken" -ForegroundColor Yellow
Write-Host "** AzdoAgentPoolName: $AzdoAgentPoolName" -ForegroundColor Yellow
Write-Host "** ContainerAppsEnvName: $ContainerAppsEnvName" -ForegroundColor Yellow
Write-Host "** ContainerRegistryName: $ContainerRegistryName" -ForegroundColor Yellow
Write-Host "** ContainerImageName: $ContainerImageName" -ForegroundColor Yellow
Write-Host "** ManagedIdentityResourceName: $ManagedIdentityResourceName" -ForegroundColor Yellow
Write-Host "** PlaceholderJobName: $PlaceholderJobName" -ForegroundColor Yellow
Write-Host "** JobName: $JobName" -ForegroundColor Yellow
Write-Host "** MaxJobs: $MaxJobs" -ForegroundColor Yellow
Write-Host "** PollingIntervalSeconds: $PollingIntervalSeconds" -ForegroundColor Yellow

Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Getting resource id for managed identity $ManagedIdentityResourceName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
$ManagedIdentityResourceId = Get-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name $ManagedIdentityResourceName | Select-Object -ExpandProperty Id
Write-Host "** Managed identity resource id: $ManagedIdentityResourceId" -ForegroundColor Green 

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating placeholder job $PlaceholderJobName for $AzdoAgentPoolName... "
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "**   ContainerAppsEnvName: $ContainerAppsEnvName"
Write-Host "**   Image: $ContainerRegistryName.azurecr.io/$ContainerImageName" 
Write-Host "**   PoolName: $AzdoAgentPoolName"
Write-Host "**   AzdoOrgUrl: $AzdoOrgUrl"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az containerapp job create -n $PlaceholderJobName -g $ResourceGroupName --environment $ContainerAppsEnvName `
    --trigger-type Manual `
    --replica-timeout 300 `
    --replica-retry-limit 0 `
    --replica-completion-count 5 `
    --parallelism 5 `
    --image "$ContainerRegistryName.azurecr.io/$ContainerImageName" `
    --cpu "2.0" `
    --memory "4Gi" `
    --secrets "personal-access-token=$PatToken" "organization-url=$AzdoOrgUrl" `
    --env-vars "AZP_TOKEN=secretref:personal-access-token" "AZP_URL=secretref:organization-url" "AZP_POOL=$AzdoAgentPoolName" "AZP_PLACEHOLDER=1" "AZP_AGENT_NAME=placeholder-agent" `
    --registry-server "$ContainerRegistryName.azurecr.io" `
    --registry-identity $ManagedIdentityResourceId

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Starting placeholder job $PlaceholderJobName for $AzdoAgentPoolName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az containerapp job start -n $PlaceholderJobName -g $ResourceGroupName

$STATUS = "Running"
while ($STATUS -eq "Running")
{
    Write-Host "Checking placeholder job status"
    Start-Sleep -Seconds 5  # Wait for 5 seconds before checking again
    $STATUS = az containerapp job execution list --name $PlaceholderJobName --resource-group $ResourceGroupName --output tsv --query '[].{Status: properties.status}'
    Write-Host "  $(Get-Date -Format HH:mm:ss) - Status is: $STATUS"
}

if ($STATUS -ne "Succeeded") {
    Write-Host "`n"
    Write-Host "*** $(Get-Date -Format HH:mm:ss) - Placeholder creation has failed!" -ForegroundColor Red
    # Write-Host "*** Deleting placeholder job for $AzdoAgentPoolName..."
    # az containerapp job delete -n $PlaceholderJobName -g $ResourceGroupName --yes
    throw 'Placeholder creation has failed!'
} 

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Creating pipeline agent job $JobName for $AzdoAgentPoolName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "**   Env: $ContainerAppsEnvName"
Write-Host "**   Image: $ContainerRegistryName.azurecr.io/$ContainerImageName" 
Write-Host "**   PoolName: $AzdoAgentPoolName"
Write-Host "**   AzdoOrgUrl: $AzdoOrgUrl"
Write-Host "**   MaxJobs: $MaxJobs"
Write-Host "**   PollingIntervalSeconds: $PollingIntervalSeconds"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
# Note: set max-executions to be how many jobs are picked up each time the job polls
# Set the polling-interval to be how often it check for new jobs (in seconds)
az containerapp job create -n "$JobName" -g "$ResourceGroupName" --environment "$ContainerAppsEnvName" `
    --trigger-type Event `
    --replica-timeout 1800 `
    --replica-retry-limit 0 `
    --replica-completion-count 1 `
    --parallelism 1 `
    --image "$ContainerRegistryName.azurecr.io/$ContainerImageName" `
    --min-executions 0 `
    --max-executions $MaxJobs `
    --polling-interval $PollingIntervalSeconds `
    --scale-rule-name "azure-pipelines" `
    --scale-rule-type "azure-pipelines" `
    --scale-rule-metadata "poolName=$AzdoAgentPoolName" "targetPipelinesQueueLength=1" `
    --scale-rule-auth "personalAccessToken=personal-access-token" "organizationURL=organization-url" `
    --cpu "2.0" `
    --memory "4Gi" `
    --secrets "personal-access-token=$PatToken" "organization-url=$AzdoOrgUrl" `
    --env-vars "AZP_TOKEN=secretref:personal-access-token" "AZP_URL=secretref:organization-url" "AZP_POOL=$AzdoAgentPoolName" `
    --registry-server "$ContainerRegistryName.azurecr.io" `
    --registry-identity $ManagedIdentityResourceId

Write-Host "`n"
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "** $(Get-Date -Format HH:mm:ss) - Deleting placeholder job for $AzdoAgentPoolName..."
Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
az containerapp job delete -n $PlaceholderJobName -g $ResourceGroupName --yes

Write-Host "`n"
if ($STATUS -eq "Failed") {
    Write-Host "$(Get-Date -Format HH:mm:ss) - Placeholder creation has failed!" -ForegroundColor Red
} 
else {
    Write-Host "$(Get-Date -Format HH:mm:ss) - Pipeline agent job setup complete." -ForegroundColor Green
}
Write-Host "`n"
