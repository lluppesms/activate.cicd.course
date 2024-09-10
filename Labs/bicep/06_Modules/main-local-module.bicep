// ----------------------------------------------------------------------------------------------------
// LOCAL Module Reference
// ----------------------------------------------------------------------------------------------------
@description('Optional. The location to deploy into')
param location string = resourceGroup().location

@description('Log Analytics Workspace Name')
param logAnalyticsName string = 'log${uniqueString(resourceGroup().id)}'
@description('Log Analytics SKU')
param logAnalyticsSKU string = 'PerGB2018'


// ----------------------------------------------------------------------------------------------------
// Module call goes here...
