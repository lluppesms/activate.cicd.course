@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param name string = 'acr${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param location string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
@allowed(['Basic', 'Premium', 'Standard'])
param acrsku string = 'Basic'

//Resources
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: acrsku
  }
  properties: {
    adminUserEnabled: false
  }
}

@description('Output the login server property for later use')
output outLoginServer string = acr.properties.loginServer
