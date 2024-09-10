// --------------------------------------------------------------------------------
// Bicep file that builds all the resource names used by other Bicep templates
// --------------------------------------------------------------------------------
param appName string = ''
@allowed(['dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'dev'

// --------------------------------------------------------------------------------
// pull resource abbreviations from a common JSON file
var resourceAbbreviations = loadJsonContent('./resourceAbbreviations.json')

// --------------------------------------------------------------------------------
var lowerAppName = replace(toLower(appName), ' ', '')
var sanitizedAppName = replace(replace(lowerAppName, '-', ''), '_', '')
var sanitizedEnvironment = toLower(environmentCode)

// --------------------------------------------------------------------------------
var functionAppName = toLower('${lowerAppName}--${resourceAbbreviations.functionSuffix}${sanitizedEnvironment}')
var baseStorageName = toLower('${sanitizedAppName}${sanitizedEnvironment}str')

// --------------------------------------------------------------------------------
output logAnalyticsWorkspaceName string =  toLower('${lowerAppName}-${sanitizedEnvironment}-${resourceAbbreviations.logWorkspaceSuffix}')
output functionAppName string            = functionAppName
output functionAppServicePlanName string = '${functionAppName}-${resourceAbbreviations.appServicePlanSuffix}'
output functionInsightsName string       = '${functionAppName}-${resourceAbbreviations.appInsightsSuffix}'

// Key Vaults and Storage Accounts can only be 24 characters long so we need to trim them
output keyVaultName string               = take(toLower('${sanitizedAppName}${sanitizedEnvironment}${resourceAbbreviations.keyVaultAbbreviation}'), 24)
output functionStorageName string        = take('${baseStorageName}${resourceAbbreviations.functionSuffix}${uniqueString(resourceGroup().id)}', 24)
output dataStorageName string            = take('${baseStorageName}${resourceAbbreviations.dataStorageSuffix}${uniqueString(resourceGroup().id)}', 24)
