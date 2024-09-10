
param demoString string
param demoInt int
param demoBool bool
param demoObject object
param demoArray array


@description('Storage Account type')
@allowed(['Premium_LRS','Standard_GRS','Standard_LRS','Standard_RAGRS'])
param storageAccountType string = 'Standard_LRS'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the Storage Account')
@minLength(5)
@maxLength(24)
param storageAccountName string = 'stg${uniqueString(resourceGroup().id)}'


output storageAccountType string = storageAccountType
output storageAccountName string = storageAccountName
output location string = location
output demoString string = demoString
output demoInt int = demoInt
output demoBool bool = demoBool
output demoObject object = demoObject
output demoArray array = demoArray

