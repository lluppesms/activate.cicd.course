param resourceGroupName string = 'rg_demo_resourcegroup'
param location string = 'eastus'
param logAnalyticsName string = 'loganalytics01'
param logAnalyticsSKU string = 'PerGB2018'

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
} 

module logAnalyticsModule 'loganalytics.bicep' = {  
  name: 'rg.scoped.logAnalytics'
  scope: az.resourceGroup(resourceGroup.name)
  params:{
    workspaceName: logAnalyticsName
    location:resourceGroup.location
    skuName: logAnalyticsSKU
  }
}

