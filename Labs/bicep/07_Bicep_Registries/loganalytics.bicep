param workspaceName string = 'logAnalytics01'
param location string = resourceGroup().location
@allowed(['Free','PerNode','PerGB2018','Standard','Premium'])
param skuName string = 'PerGB2018'

resource logWorkspaceResources 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

output name string = logWorkspaceResources.name
output id string = logWorkspaceResources.id
