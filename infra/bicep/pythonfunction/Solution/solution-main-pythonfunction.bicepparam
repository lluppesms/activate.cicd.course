// ----------------------------------------------------------------------------------------------------
// Bicep Parameter File
// ----------------------------------------------------------------------------------------------------
using 'solution-main-pythonfunction.bicep'

param environmentCode = '#{envCode}#'
param location = '#{AZURE_LOCATION}#'
param keyVaultOwnerUserId = '#{KEYVAULT_OWNER_USERID}#'
