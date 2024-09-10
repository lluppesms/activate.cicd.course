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

module logAnalyticsModule 
  name:'loganalytics.avm.module.01'
  params:{
  }
}

module appInsitesModule 
  name: 'appinsites.avm.module.02' 
  params: {
  }
}

