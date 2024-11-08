// --------------------------------------------------------------------------------
// Creates a Log Analytics Workspace
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = resourceGroup().location

// --------------------------------------------------------------------------------
var resourceToken = toLower(uniqueString(resourceGroup().id, environmentCode, location))
var logAnalyticsWorkspaceName = 'law-${resourceToken}'

// --------------------------------------------------------------------------------
resource logWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
        name: 'PerGB2018' // Standard
    }
    retentionInDays: 90
    //you can limit the maximum daily ingestion on the Workspace by providing a value for dailyQuotaGb. 
    // Note: Bicep expects an integer, however in order to set the minimum possible value of 0.023 GB
    // you need to pass it as a string which will work just fine.
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

// --------------------------------------------------------------------------------
output id string = logWorkspaceResource.id
output name string = logWorkspaceResource.name
output resourceToken string = resourceToken
