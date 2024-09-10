@description('The location of the Log Analytics Workspace')
param location string = resourceGroup().location

@description('The SKU name of the Log Analytics Workspace')
@allowed(['Free','PerNode','PerGB2018','Standard','Premium'])
param skuName string = 'PerGB2018'

@description('Do we deploy the resource or not?')
param deployResource bool = true

@description('Loop counter')
@minValue(1)
param loopCount int = 1

//loop over the workspaces for loopCount and check if we are to deploy a storage account based on a condition
resource logWorkspaceResources 'Microsoft.OperationalInsights/workspaces@2023-09-01' = [for i in range(0, loopCount): if (deployResource) {
  name: '${i}logAnalytics${uniqueString(resourceGroup().id)}' //dynamic name based on loop
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
}]

// loop over outputs... Note: this will throw an error if deployResource set to false
output workspaceInfo array = [for i in range(0, loopCount): {
  id: logWorkspaceResources[i].id
  name:logWorkspaceResources[i].name
  sku: logWorkspaceResources[i].properties.sku.name
}]
output accountsDeployed int = loopCount
output deployResource bool = deployResource
