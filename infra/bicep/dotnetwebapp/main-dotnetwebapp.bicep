// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = resourceGroup().location

param storageSku string = 'Standard_LRS'
param webSiteSku string = 'B1'

param apiKey string = 'secret'

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
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    environmentCode: environmentCode
    location: location
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
module storageModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'storage${deploymentSuffix}'
  params: {
    storageSku: storageSku
    storageAccountName: // get proper output from resourceNames module
    location: location
    commonTags: commonTags
  }
}

module webSiteModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'webSite${deploymentSuffix}'
  params: {
    webSiteName: // get proper output from resourceNames module
    location: location
    appInsightsLocation: location
    commonTags: commonTags
    sku: webSiteSku
    environmentCode: environmentCode
    workspaceId:  // get proper output from log analytics module
  }
}

// In a Linux app service, any nested JSON app key like AppSettings:MyKey needs to be 
// configured in App Service as AppSettings__MyKey for the key name. 
// In other words, any : should be replaced by __ (double underscore).
// NOTE: See https://learn.microsoft.com/en-us/azure/app-service/configure-common?tabs=portal  
module webSiteAppSettingsModule '###-ENTER-MODULE-NAME-HERE-###' = {
  name: 'webSiteAppSettings${deploymentSuffix}'
  params: {
    webAppName:  // get proper output from webSiteModule module
    appInsightsKey:  // get proper output from webSiteModule module
    customAppSettings: {
      AppSettings__AppInsights_InstrumentationKey:  // get proper output from webSiteModule module
      AppSettings__EnvironmentName: environmentCode
      AppSettings__EnableSwagger: appSwaggerEnabled
      AppSettings__DataSource: appDataSource
      AppSettings__ApiKey: apiKey
      AzureAD__Instance: adInstance
      AzureAD__Domain: adDomain
      AzureAD__TenantId: adTenantId
      AzureAD__ClientId: adClientId
      AzureAD__CallbackPath: adCallbackPath
    }
  }
}

output resourceToken string = // get proper output from resourceNames module
output hostName string =  // get proper output from webSiteModule module
