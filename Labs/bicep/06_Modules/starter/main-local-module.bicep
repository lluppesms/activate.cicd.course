// ----------------------------------------------------------------------------------------------------
// LOCAL Module Reference
// ----------------------------------------------------------------------------------------------------
@description('Optional. The location to deploy into')
param location string = resourceGroup().location

@description('Log Analytics Workspace Name')
param logAnalyticsName string = 'log${uniqueString(resourceGroup().id)}'
@description('Log Analytics SKU')
param logAnalyticsSKU string = 'PerGB2018'

@description('Application Insights Name')
param appInsightsName string = 'appinsights${uniqueString(resourceGroup().id)}'

// ----------------------------------------------------------------------------------------------------
// Module call goes here...
module logAnalyticsModule 'loganalytics.bicep' = {  
  name: 'logAnalytics.local.deploy.01'
  params:{
    workspaceName: logAnalyticsName
    location:location
    skuName: logAnalyticsSKU
  }
}

module appInsightsModule 'appinsights.bicep' = {  
  name: 'appInsights.local.deploy.01'
  params:{
    appInsightsName: appInsightsName
    location:location
    workspaceId: logAnalyticsModule.outputs.id
  }
}
