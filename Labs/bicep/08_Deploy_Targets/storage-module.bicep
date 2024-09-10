param storageAccountName string
param location string = resourceGroup().location

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

@description('Return the Storage Account Resource ID')
output blobResourceId string = storageAccountResource.id
