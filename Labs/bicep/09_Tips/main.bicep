// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
param appName string = take('myapp${uniqueString(resourceGroup().id)}',12)
@allowed(['dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'dev'
param location string = resourceGroup().location
param keyVaultOwnerUserId string = ''

// this is a parameter because I can use the function here - I never expect it to be passed
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
// a suffix to put on all of the deployment names to make them unique
var deploymentSuffix = '-${runDateTime}'
// Tags that are common to all resources
var commonTags = {         
  LastDeployed: runDateTime
  Application: appName
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    appName: appName
    environmentCode: environmentCode
  }
}
// --------------------------------------------------------------------------------
module logAnalyticsWorkspaceModule 'loganalytics.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    workspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}

module functionStorageModule 'storageaccount.bicep' = {
  name: 'functionstorage${deploymentSuffix}'
  params: {
    storageAccountName: resourceNames.outputs.functionStorageName
    location: location
    commonTags: commonTags
  }
}

module functionModule 'functionapp.bicep' = {
  name: 'function${deploymentSuffix}'
  dependsOn: [ functionStorageModule ]
  params: {
    functionAppName: resourceNames.outputs.functionAppName
    functionAppServicePlanName: resourceNames.outputs.functionAppServicePlanName
    functionInsightsName: resourceNames.outputs.functionInsightsName
    appInsightsLocation: location
    location: location
    commonTags: commonTags
    functionStorageAccountName: functionStorageModule.outputs.name
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}

module dataStorageModule 'storageaccount.bicep' = {
  name: 'datastorage${deploymentSuffix}'
  params: {
    storageAccountName: resourceNames.outputs.dataStorageName
    location: location
    commonTags: commonTags
  }
}
module keyVaultModule 'keyvault.bicep' = {
  name: 'keyvault${deploymentSuffix}'
  dependsOn: [ functionModule ]
  params: {
    keyVaultName: resourceNames.outputs.keyVaultName
    location: location
    commonTags: commonTags
    adminUserObjectIds: [ keyVaultOwnerUserId ]
    applicationUserObjectIds: [ functionModule.outputs.principalId ]
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}
module keyVaultSecretList 'keyvaultlistsecretnames.bicep' = {
  name: 'keyVaultSecretListNames${deploymentSuffix}'
  dependsOn: [ keyVaultModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    location: location
    userManagedIdentityId: keyVaultModule.outputs.userManagedIdentityId
  }
}
module keyVaultSecretStorage 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecretStorage${deploymentSuffix}'
  dependsOn: [ keyVaultModule, dataStorageModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'DataStorageConnectionAppSetting'
    storageAccountName: dataStorageModule.outputs.name
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}
module functionAppSettingsModule 'functionappsettings.bicep' = {
  name: 'functionAppSettings${deploymentSuffix}'
  params: {
    functionAppName: functionModule.outputs.name
    functionStorageAccountName: functionStorageModule.outputs.name
    functionInsightsKey: functionModule.outputs.insightsKey
    customAppSettings: {
      DataStorageConnectionAppSetting: '@Microsoft.KeyVault(VaultName=${keyVaultModule.outputs.name};SecretName=DataStorageConnectionAppSetting)'
    }
  }
}
