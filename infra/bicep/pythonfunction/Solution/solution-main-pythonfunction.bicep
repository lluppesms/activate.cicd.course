// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = resourceGroup().location
param keyVaultOwnerUserId string = ''

// optional parameters
@allowed(['Standard_LRS','Standard_GRS','Standard_RAGRS'])
param storageSku string = 'Standard_LRS'
//param functionName string = 'process'
param functionAppSku string = 'Y1'
param functionAppSkuFamily string = 'Y'
param functionAppSkuTier string = 'Dynamic'
param keyVaultOwnerIpAddress string = ''
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
var deploymentSuffix = '-${runDateTime}'
var commonTags = {         
  LastDeployed: runDateTime
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    environmentCode: environmentCode
    location: location
    functionStorageNameSuffix: 'func'
    dataStorageNameSuffix: 'data'
  }
}

// --------------------------------------------------------------------------------
module logAnalyticsWorkspaceModule 'loganalyticsworkspace.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    logAnalyticsWorkspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}

// --------------------------------------------------------------------------------
module functionStorageModule 'storageaccount.bicep' = {
  name: 'functionstorage${deploymentSuffix}'
  params: {
    storageAccountName: resourceNames.outputs.functionStorageName
    location: location
    commonTags: commonTags
    storageSku: storageSku
    containerNames: []
  }
}
module dataStorageModule 'storageaccount.bicep' = {
  name: 'datastorage${deploymentSuffix}'
  params: {
    storageAccountName: resourceNames.outputs.dataStorageName
    location: location
    commonTags: commonTags
    storageSku: storageSku
    containerNames: [
      'inputfiles'
      'outputfiles'
    ]
  }
}
module functionModule 'functionpythonapp.bicep' = {
  name: 'functionApp${deploymentSuffix}'
  dependsOn: [ functionStorageModule ]
  params: {
    functionAppName: resourceNames.outputs.functionAppName
    functionAppServicePlanName: resourceNames.outputs.functionAppServicePlanName
    functionInsightsName: resourceNames.outputs.functionInsightsName

    appInsightsLocation: location
    location: location
    commonTags: commonTags

    functionAppSku: functionAppSku
    functionAppSkuFamily: functionAppSkuFamily
    functionAppSkuTier: functionAppSkuTier
    functionStorageAccountName: functionStorageModule.outputs.name
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}
module keyVaultModule 'keyvault.bicep' = {
  name: 'keyvault${deploymentSuffix}'
  dependsOn: [ functionModule ]
  params: {
    keyVaultName: resourceNames.outputs.keyVaultName
    location: location
    commonTags: commonTags
    adminUserObjectIds: []
    keyVaultOwnerUserId: keyVaultOwnerUserId
    applicationUserObjectIds: [ functionModule.outputs.principalId ]
    keyVaultOwnerIpAddress: keyVaultOwnerIpAddress
    enableSoftDelete: false
    createUserAssignedIdentity: true
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}

module keyVaultSecretList 'keyvaultlistsecretnames.bicep' = {
  name: 'keyVault-Secret-List-Names${deploymentSuffix}'
  dependsOn: [ keyVaultModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    location: location
    userManagedIdentityId: keyVaultModule.outputs.userManagedIdentityId
  }
}

module keyVaultSecret1 'keyvaultsecret.bicep' = {
  name: 'keyVaultSecret1${deploymentSuffix}'
  dependsOn: [ keyVaultModule, functionModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'functionAppInsightsKey'
    secretValue: functionModule.outputs.insightsKey
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}
module keyVaultSecret2 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecret2${deploymentSuffix}'
  dependsOn: [ keyVaultModule, functionStorageModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'functionStorageAccountConnectionString'
    storageAccountName: functionStorageModule.outputs.name
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}
module keyVaultSecret3 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecret3${deploymentSuffix}'
  dependsOn: [ keyVaultModule, dataStorageModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'DataStorageConnectionAppSetting'
    storageAccountName: dataStorageModule.outputs.name
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}
module functionAppSettingsModule 'functionpythonappsettings.bicep' = {
  name: 'functionAppSettings${deploymentSuffix}'
  dependsOn: [ keyVaultSecret1, keyVaultSecret2, keyVaultSecret3, ]
  params: {
    functionAppName: functionModule.outputs.name
    functionStorageAccountName: functionModule.outputs.storageAccountName
    functionInsightsKey: functionModule.outputs.insightsKey
    customAppSettings: {
      DataStorageConnectionAppSetting: '@Microsoft.KeyVault(VaultName=${keyVaultModule.outputs.name};SecretName=DataStorageConnectionAppSetting)'
    }
  }
}

output resourceToken string = resourceNames.outputs.resourceToken
output appName string = resourceNames.outputs.functionAppName
output hostName string = functionModule.outputs.defaultHostName
