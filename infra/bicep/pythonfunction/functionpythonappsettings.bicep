// --------------------------------------------------------------------------------
// This BICEP file will add unique Configuration settings to a web or function app
// --------------------------------------------------------------------------------
param functionAppName string = 'myfunctionname'
param functionStorageAccountName string = 'myfunctionstoragename'
param functionInsightsKey string = 'myKey'
param customAppSettings object = {}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2023-05-01' existing = { 
  name: functionStorageAccountName 
}
var accountKey = storageAccountResource.listKeys().keys[0].value
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountResource.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${accountKey}'

var BASE_SLOT_APPSETTINGS = {
  AzureWebJobsStorage: storageAccountConnectionString
  WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
  WEBSITE_CONTENTSHARE: functionAppName
  // APPINSIGHTS_INSTRUMENTATIONKEY: functionInsightsKey
  APPLICATIONINSIGHTS_CONNECTION_STRING: 'InstrumentationKey=${functionInsightsKey}'
  FUNCTIONS_WORKER_RUNTIME: 'python'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: 'false'
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' existing = {
  name: functionAppName
}

resource siteConfig 'Microsoft.Web/sites/config@2023-12-01' = {
  name: 'appsettings'
  parent: functionApp
  properties: union(BASE_SLOT_APPSETTINGS, customAppSettings)
}
