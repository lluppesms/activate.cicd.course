// ----------------------------------------------------------------------------------------------------
// I would love to use main.bicepparam file format instead of main.parameters.json, 
// but the AzureResourceManagerTemplateDeployment@3 task does not support it yet... :(
//   See https://github.com/microsoft/azure-pipelines-tasks/issues/18521
//   The issue is in code review on Feb 9, 2024, so it should be coming soon...
// ----------------------------------------------------------------------------------------------------

using './main-web-app.bicep'

param appName = '#{appName}#'
param environmentCode = '#{environmentNameLower}#'

param storageSku = '#{storageSku}#'
param webSiteSku = '#{webSiteSku}#'

param apiKey = '#{apiKey}#'

param adInstance = '#{adInstance}#'
param adDomain = '#{adDomain}#'
param adTenantId = '#{adTenantId}#'
param adClientId = '#{adClientId}#'

param location = '#{location}#'
