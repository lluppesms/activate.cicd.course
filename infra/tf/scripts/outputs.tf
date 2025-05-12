output "resource_groups" {
    value = module.resource_groups
}

output "application_insights" {
    value     = module.app_insights
    sensitive = true
}