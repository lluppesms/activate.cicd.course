
# resource "azurerm_resource_group" "asp_rg" {
#   name     = "${var.resource_group_name}-${var.env}"
#   location = var.location
# }
####

module "resource_groups" {
  #source          = "git@github.com:bootcamp12345/euw-tf-modules-1.git//Resource_Groups?ref=v2"
  source          = "../modules/Resource_Groups"
  resource_groups = var.resource_groups
}

module "app_insights" {
  #source                        = "git@github.com:bootcamp12345/euw-tf-modules-1.git//AppInsights?ref=v1"
  source                       = "../modules/AppInsights"
  resource_group_name          = var.app_insights_resource_group_name
  app_insights_additional_tags = var.app_insights_additional_tags
  application_insights         = var.application_insights
  depends_on                   = [module.resource_groups]
}

resource "azurerm_service_plan" "example" {
  name = "${var.app_service_plan_name}-${var.env}"
  #resource_group_name = module.resource_groups.resource_group_ids_map.0.resource_group
  #location            = module.resource_groups.resource_group_ids_map.0.location
  resource_group_name = var.resource_groups["resource_group_1"].name
  location            = var.resource_groups["resource_group_1"].location
  os_type             = var.asp_os_type
  sku_name            = var.asp_sku
  depends_on          = [module.app_insights]
}
