@description('The name of the application insights instance.')
param appInsightsName string = 'appInsights01'

@description('The log analytics workspace to store audit logs.')
param workspaceId string

param location string = resourceGroup().location

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: workspaceId
  }
}

output name string = appInsightsResource.name
output id string = appInsightsResource.id
