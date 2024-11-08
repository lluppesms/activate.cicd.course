// --------------------------------------------------------------------------------
// Main Bicep file that creates Azure Resources for a Python Azure Function
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = resourceGroup().location
param keyVaultOwnerUserId string = ''

// optional parameters
@allowed(['Standard_LRS','Standard_GRS','Standard_RAGRS'])
param storageSku string = 'Standard_LRS'
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
module logAnalyticsWorkspaceModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    logAnalyticsWorkspaceName: // get proper output from resourceNames module
    location: location
    commonTags: commonTags
  }
}

// --------------------------------------------------------------------------------
module functionStorageModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'functionstorage${deploymentSuffix}'
  params: {
    storageAccountName: // get proper output from resourceNames module
    location: location
    commonTags: commonTags
    storageSku: storageSku
    containerNames: []
  }
}
module dataStorageModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'datastorage${deploymentSuffix}'
  params: {
    storageAccountName: // get proper output from resourceNames module
    location: location
    commonTags: commonTags
    storageSku: storageSku
    containerNames: [
      'inputfiles'
      'outputfiles'
    ]
  }
}

module functionModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'functionApp${deploymentSuffix}'
  params: {
    functionAppName: // get proper output from resourceNames module
    functionAppServicePlanName: // get proper output from resourceNames module
    functionInsightsName: // get proper output from resourceNames module

    appInsightsLocation: location
    location: location
    commonTags: commonTags

    functionAppSku: functionAppSku
    functionAppSkuFamily: functionAppSkuFamily
    functionAppSkuTier: functionAppSkuTier
    functionStorageAccountName:  // get proper output from function storage module
    workspaceId: // get proper output from log analytics module
  }
}
module keyVaultModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'keyvault${deploymentSuffix}'
  dependsOn: [ functionModule ]
  params: {
    keyVaultName: // get proper output from resourceNames module
    location: location
    commonTags: commonTags
    adminUserObjectIds: []
    keyVaultOwnerUserId: keyVaultOwnerUserId
    applicationUserObjectIds: [ functionModule.outputs.principalId ]
    keyVaultOwnerIpAddress: keyVaultOwnerIpAddress
    enableSoftDelete: false
    createUserAssignedIdentity: true
    workspaceId: // get proper output from log analytics module
  }
}

module keyVaultSecret1 'keyvaultsecret.bicep' = {
  name: 'keyVaultSecret1${deploymentSuffix}'
  dependsOn: [ keyVaultModule, functionModule ]
  params: {
    keyVaultName: // get proper output from keyvault module
    secretName: 'functionAppInsightsKey'
    secretValue: // get proper output from function module
  }
}
module keyVaultSecret2 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecret2${deploymentSuffix}'
  dependsOn: [ keyVaultModule, functionStorageModule ]
  params: {
    keyVaultName: // get proper output from keyvault module
    secretName: 'functionStorageAccountConnectionString'
    storageAccountName:  // get proper output from function storage module
  }
}
module keyVaultSecret3 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecret3${deploymentSuffix}'
  dependsOn: [ keyVaultModule, dataStorageModule ]
  params: {
    keyVaultName: // get proper output from keyvault module
    secretName: 'DataStorageConnectionAppSetting'
    storageAccountName: dataStorageModule.outputs.name
  }
}
module functionAppSettingsModule 'functionpythonappsettings.bicep' = {
  name: 'functionAppSettings${deploymentSuffix}'
  dependsOn: [ keyVaultSecret1, keyVaultSecret2, keyVaultSecret3, ]
  params: {
    functionAppName:  // get proper output from functionModule module
    functionStorageAccountName:  // get proper output from functionModule module
    functionInsightsKey:  // get proper output from functionModule module
    customAppSettings: {
      DataStorageConnectionAppSetting: '@Microsoft.KeyVault(VaultName=${keyVaultModule.outputs.name};SecretName=DataStorageConnectionAppSetting)'
    }
  }
}

output resourceToken string = // get proper output from resourceNames module
output hostName string = // get proper output from functionModule module
