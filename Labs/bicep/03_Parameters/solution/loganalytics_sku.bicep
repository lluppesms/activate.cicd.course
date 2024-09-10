@description('The name of the Log Analytics Workspace')
param logAnalyticsWorkspaceName string = 'logAnalytics01'

@description('The location of the Log Analytics Workspace')
param location string = resourceGroup().location

@description('The SKU name of the Log Analytics Workspace')
@allowed(['Free','PerNode','PerGB2018','Standard','Premium'])
param skuName string = 'PerGB2018'

resource logWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    //you can limit the maximum daily ingestion on the Workspace by providing a value for dailyQuotaGb. 
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}
