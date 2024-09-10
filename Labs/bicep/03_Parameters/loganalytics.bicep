param logAnalyticsWorkspaceName string = 'logAnalytics01'
param location string = resourceGroup().location
param retentionInDays int = 30

resource logWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    features: {
      searchVersion: 1
    }
    //you can limit the maximum daily ingestion on the Workspace by providing a value for dailyQuotaGb. 
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}
