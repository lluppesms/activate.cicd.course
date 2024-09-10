// ----------------------------------------------------------------------------------------------------
// REMOTE PUBLIC Module Reference
// ----------------------------------------------------------------------------------------------------
@description('Optional. The location to deploy into')
param location string = resourceGroup().location

@description('Generate random storage account name')
param workspaceName string = 'logpub${uniqueString(resourceGroup().id)}'

@description('Application Insights Name')
param appInsightsName string = 'appinsights${uniqueString(resourceGroup().id)}'

// ----------------------------------------------------------------------------------------------------

module logAnalyticsModule 'br/public:avm/res/operational-insights/workspace:0.6.0'= {
  name:'loganalytics.avm.module.01'
  params:{
    name: workspaceName
    location: location
  }
}

module appInsitesModule 'br/public:avm/res/insights/component:0.4.1' = { 
  name: 'appinsites.avm.module.02' 
  params: {
    name: appInsightsName
    workspaceResourceId: logAnalyticsModule.outputs.logAnalyticsWorkspaceId
  }
}

