resource logWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'logAnalytics01'
  location: 'eastus'
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}
