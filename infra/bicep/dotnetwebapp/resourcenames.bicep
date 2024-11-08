// --------------------------------------------------------------------------------
// Bicep file that builds all the resource names used by other Bicep templates
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = 'eastus'

// --------------------------------------------------------------------------------
// pull resource abbreviations from a common JSON file
var resourceAbbreviations = loadJsonContent('./resourceAbbreviations.json')

// --------------------------------------------------------------------------------
var resourceToken = toLower(uniqueString(resourceGroup().id, environmentCode, location))

var webSiteName     = toLower('${resourceAbbreviations.webSiteAbbreviation}-${resourceToken}')
var baseStorageName = toLower('${resourceAbbreviations.webSiteAbbreviation}${resourceAbbreviations.storageAccountAbbreviation}${resourceToken}')

// --------------------------------------------------------------------------------
output resourceToken string             = resourceToken
output webSiteName string               = webSiteName
output logAnalyticsWorkspaceName string = '${webSiteName}-${resourceAbbreviations.logWorkspaceAbbreviation}'
output webSiteAppServicePlanName string = '${webSiteName}-${resourceAbbreviations.appServicePlanAbbreviation}'
output webSiteAppInsightsName string    = '${webSiteName}-${resourceAbbreviations.appInsightsAbbreviation}'

// Key Vaults and Storage Accounts can only be 24 characters long
output keyVaultName string              = take('${resourceAbbreviations.webSiteAbbreviation}${resourceAbbreviations.keyVaultAbbreviation}${resourceToken}', 24)
output storageAccountName string        = take('${baseStorageName}${resourceAbbreviations.storageAccountAbbreviation}', 24)
