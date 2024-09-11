// Template Spec Module Reference
param location string = resourceGroup().location
param storageAccountName string = 'rem${uniqueString(resourceGroup().id)}'

// specNameFormat='ts:/${subscriptionId}/${resourceGroupName}/${specName}:${specVersion}'
module storage 'ts:/xxxxxxxx-xxxx-xxxx-xxxxxxxx/rg_demo/BasicStorageAccount:1.0'= {
  name:'template.spec.04'
  params:{
    storageAccountName: storageAccountName
    location: location
  }
}
