// --------------------------------------------------------------------------------
// This BICEP file will create a Azure Website
// --------------------------------------------------------------------------------
param webSiteName string = ''
param location string = resourceGroup().location
param appInsightsLocation string = resourceGroup().location
param environmentCode string = 'dev'
param commonTags object = {}
@allowed(['F1','B1','B2','S1','S2','S3'])
param sku string = 'B1'

@description('The workspace to store audit logs.')
param workspaceId string = ''

// --------------------------------------------------------------------------------
var templateTag = { TemplateFile: '~website.bicep'}
var azdTag = environmentCode == 'azd' ? { 'azd-service-name': 'web' } : {}
var tags = union(commonTags, templateTag)
var webSiteTags = union(commonTags, templateTag, azdTag)

// --------------------------------------------------------------------------------
var linuxFxVersion = 'DOTNETCORE|8.0' // 	The runtime stack of web app
var webAppKind = 'linux'
var appServicePlanName = toLower('${webSiteName}-appsvc')
var appInsightsName = toLower('${webSiteName}-insights')

// --------------------------------------------------------------------------------
resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: appInsightsLocation
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: workspaceId
  }
}

resource appServiceResource 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  kind: webAppKind
  properties: {
    reserved: true
  }
}

resource webSiteResource 'Microsoft.Web/sites@2023-01-01' = {
  name: webSiteName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: webSiteTags
  properties: {
    serverFarmId: appServiceResource.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      remoteDebuggingEnabled: false
      appSettings: [
        { 
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsResource.properties.InstrumentationKey 
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsightsResource.properties.InstrumentationKey}'
        }
      ]
    }
  }
}

resource webSiteAppSettings 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: webSiteResource
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    httpLogs: {
      fileSystem: {
        retentionInMb: 40
        enabled: true
      }
    }
    failedRequestsTracing: {
      enabled: true
    }
    detailedErrorMessages: {
      enabled: true
    }
  }
}

// can't seem to get this to work right... tried multiple ways...  keep getting this error:
//    No route registered for '/api/siteextensions/Microsoft.ApplicationInsights.AzureWebSites'.
// resource webSiteAppInsightsExtension 'Microsoft.Web/sites/siteextensions@2020-06-01' = {
//   parent: webSiteResource
//   name: 'Microsoft.ApplicationInsights.AzureWebSites'
//   dependsOn: [ appInsightsResource] or [ appInsightsResource, webSiteAppSettings ]
// }

resource webSiteMetricsLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${webSiteResource.name}-metrics'
  scope: webSiteResource
  properties: {
    workspaceId: workspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        // retentionPolicy: {
        //   days: 30
        //   enabled: true 
        // }
      }
    ]
  }
}

// https://learn.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs
resource webSiteAuditLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${webSiteResource.name}-auditlogs'
  scope: webSiteResource
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
        // retentionPolicy: {
        //   days: 30
        //   enabled: true 
        // }
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
        // retentionPolicy: {
        //   days: 30
        //   enabled: true 
        // }
      }
    ]
  }
}

resource appServiceMetricLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${appServiceResource.name}-metrics'
  scope: appServiceResource
  properties: {
    workspaceId: workspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        // retentionPolicy: {
        //   days: 30
        //   enabled: true 
        // }
      }
    ]
  }
}
output principalId string = webSiteResource.identity.principalId
output name string = webSiteName
output appInsightsName string = appInsightsName
output appInsightsKey string = appInsightsResource.properties.InstrumentationKey
// Note: This will give you a warning saying it's not right, but it will contain the right value!
// output ipAddress string = webSiteResource.properties.inboundIpAddress 
