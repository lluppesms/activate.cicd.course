@export()
@description('User defined type for App Service Isolated SKUs')
type isolatedAppServicePlanSku = 'I1v2' | 'I1mv2' | 'I2v2' | 'I2mv2' | 'I3v2' | 'I3mv2' | 'I4v2' | 'I4mv2' | 'I5v2' | 'I5mv2' | 'I6v2'

@export()
@description('Supported language workers for Function Apps')
type functionWorkerRuntimes = 'dotnet' | 'node' | 'python' | 'java' | 'powershell'

@export()
@description('An array of strings, representing the zones to deploy to')
type zoneConfigurationValues = ('1' | '2' | '3')[]

@export()
@description('Configuration for App Service Plan')
type appServicePlanConfiguration = {
  @description('The name of the App Service Plan that will be inserted into the standard naming convention')
  appServicePlanNameSuffix: string

  @description('The SKU of the App Service Plan')
  appServicePlanSku: isolatedAppServicePlanSku

  @description('The number of instances to deploy')
  instanceCount: int

  @description('The zones that the plan will be deployed to.  This is an array of strings, where each string is a zone number (1, 2, or 3)')
  zones: zoneConfigurationValues

  @description('The Azure AD object ID of the group that will get Web Plan Contributor access to this plan')
  contributorGroupObjectId: string

  @description('The resource group name that the App Service Plan will be deployed to')
  resourceGroupName: string

  @description('The tags to apply to the App Service Plan.  This is an object where each key is a tag name and the value is the tag value')
  tags: object
}

@export()
@description('An array of App Service Plan Configurations')
type appSerivcePlanConfigurations = appServicePlanConfiguration[]

@export()
@description('Configuration for an API Management workspace')
type apimWorkspaceConfiguration = {
  @description('The name of the API Management service workspace to create')
  name: string

  @description('The Entra object id of the group that will have contributor access to the workspace')
  workspaceContributorGroupObjectId: string
}

@export()
type apimWorkspaceConfigurations = apimWorkspaceConfiguration[]
