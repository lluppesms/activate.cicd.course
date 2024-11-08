// --------------------------------------------------------------------------------
// Bicep file that builds all the resource names used by other Bicep templates
// --------------------------------------------------------------------------------
param environmentCode string = 'dev'
param location string = 'eastus'
param functionStorageNameSuffix string = 'func'
param dataStorageNameSuffix string = 'data'

// --------------------------------------------------------------------------------
// pull resource abbreviations from a common JSON file
var resourceAbbreviations = loadJsonContent('./resourceAbbreviations.json')

// --------------------------------------------------------------------------------
var resourceToken = toLower(uniqueString(resourceGroup().id, environmentCode, location))

// --------------------------------------------------------------------------------
var functionAppName = toLower('${resourceAbbreviations.functionAbbreviation}-${resourceToken}')
var baseStorageName = toLower('${resourceAbbreviations.functionAbbreviation}${resourceAbbreviations.storageAccountAbbreviation}${resourceToken}')

// --------------------------------------------------------------------------------
output resourceToken string              = resourceToken
output functionAppName string            = functionAppName
output logAnalyticsWorkspaceName string  = '${functionAppName}-${resourceAbbreviations.logWorkspaceAbbreviation}'
output functionAppServicePlanName string = '${functionAppName}-${resourceAbbreviations.appServicePlanAbbreviation}'
output functionInsightsName string       = '${functionAppName}-${resourceAbbreviations.appInsightsAbbreviation}'
output managedIdentityName string        = '${functionAppName}-${resourceAbbreviations.identityAbbreviation}'

// Key Vaults and Storage Accounts can only be 24 characters long
output keyVaultName string               = take('${resourceAbbreviations.functionAbbreviation}${resourceAbbreviations.keyVaultAbbreviation}${resourceToken}', 24)
output functionStorageName string        = take('${baseStorageName}${functionStorageNameSuffix}', 24)
output dataStorageName string            = take('${baseStorageName}${dataStorageNameSuffix}', 24)
