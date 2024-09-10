// ----------------------------------------------------------------------------------------------------
// REMOTE Private Module Reference
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

module logAnalyticsModule '' = {
  name:'loganalytics.private.module.01'
  params:{
    workspaceName: logAnalyticsName
    location:location
    skuName: logAnalyticsSKU
  }
}

module appInsitesModule '' = { 
  name: 'appinsites.private.module.02' 
  params: {
    appInsightsName: appInsightsName
    location:location
    workspaceId: logAnalyticsModule.outputs.id
  }
}
