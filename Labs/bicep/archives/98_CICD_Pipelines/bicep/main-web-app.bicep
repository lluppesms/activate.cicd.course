// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
// To deploy this Bicep manually:
// 	 az login
//   az account set --subscription <subscriptionId>
//   az deployment group create -n main-deploy-20221129T150000Z --resource-group rg_dadabase_test --template-file 'main.bicep' --parameters appName=xxx-dadabase-test environmentCode=demo keyVaultOwnerUserId=xxxxxxxx-xxxx-xxxx
// --------------------------------------------------------------------------------
param appName string = ''
param environmentCode string = 'azd'
param location string = resourceGroup().location

param storageSku string = 'Standard_LRS'
param webSiteSku string = 'B1'

param apiKey string = ''

param adInstance string = environment().authentication.loginEndpoint // 'https://login.microsoftonline.com/'
param adDomain string = ''
param adTenantId string = ''
param adClientId string = ''
param adCallbackPath string = '/signin-oidc'

param appDataSource string = 'JSON'
param appSwaggerEnabled string = 'true'

param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
var deploymentSuffix = '-${runDateTime}'
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
module logAnalyticsWorkspaceModule 'loganalyticsworkspace.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    logAnalyticsWorkspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}
module storageModule 'storageaccount.bicep' = {
  name: 'storage${deploymentSuffix}'
  params: {
    storageSku: storageSku
    storageAccountName: resourceNames.outputs.storageAccountName
    location: location
    commonTags: commonTags
  }
}
module webSiteModule 'website.bicep' = {
  name: 'webSite${deploymentSuffix}'
  params: {
    webSiteName: resourceNames.outputs.webSiteName
    location: location
    appInsightsLocation: location
    commonTags: commonTags
    sku: webSiteSku
    environmentCode: environmentCode
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}
module keyVaultModule 'keyvault.bicep' = {
  name: 'keyvault${deploymentSuffix}'
  dependsOn: [ webSiteModule ]
  params: {
    keyVaultName: resourceNames.outputs.keyVaultName
    location: location
    commonTags: commonTags
    applicationUserObjectIds: [ webSiteModule.outputs.principalId ]
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
module keyVaultSecret4 'keyvaultsecretstorageconnection.bicep' = {
  name: 'keyVaultSecret4${deploymentSuffix}'
  dependsOn: [ keyVaultModule, storageModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'StorageConnectionAppSetting'
    storageAccountName: storageModule.outputs.name
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}
// In a Linux app service, any nested JSON app key like AppSettings:MyKey needs to be 
// configured in App Service as AppSettings__MyKey for the key name. 
// In other words, any : should be replaced by __ (double underscore).
// NOTE: See https://learn.microsoft.com/en-us/azure/app-service/configure-common?tabs=portal  
module webSiteAppSettingsModule 'websiteappsettings.bicep' = {
  name: 'webSiteAppSettings${deploymentSuffix}'
  params: {
    webAppName: webSiteModule.outputs.name
    appInsightsKey: webSiteModule.outputs.appInsightsKey
    customAppSettings: {
      AppSettings__AppInsights_InstrumentationKey: webSiteModule.outputs.appInsightsKey
      AppSettings__EnvironmentName: environmentCode
      AppSettings__EnableSwagger: appSwaggerEnabled
      AppSettings__DataSource: appDataSource
      AppSettings__ApiKey: apiKey
      AzureAD__Instance: adInstance
      AzureAD__Domain: adDomain
      AzureAD__TenantId: adTenantId
      AzureAD__ClientId: adClientId
      AzureAD__CallbackPath: adCallbackPath
      StorageConnectionAppSetting: '@Microsoft.KeyVault(VaultName=${keyVaultModule.outputs.name};SecretName=StorageConnectionAppSetting)'
    }
  }
}
