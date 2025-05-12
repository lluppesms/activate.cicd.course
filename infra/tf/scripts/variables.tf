# variable "subscription_id" {
#     type = string
# }

# variable "tenant_id" {
#     type = string
# }

variable "location" {
    type = string
}

variable "env" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "app_service_plan_name" {
    type = string
}
variable "asp_os_type" {
    type = string
}
variable "asp_sku" {
    type = string
}

######################################
########RESOURCE_GRP##################
######################################
variable "resource_groups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default = {}
}


######################################
########APP_INSIGHTS##################
######################################
variable "app_insights_resource_group_name" {
    type = string
}

variable "app_insights_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "application_insights" {
  type = map(object({
    name                                  = string
    application_type                      = string
    retention_in_days                     = number
    daily_data_cap_in_gb                  = number
    daily_data_cap_notifications_disabled = bool
    sampling_percentage                   = number
    disable_ip_masking                    = bool
  }))
  description = "Map containing Application Insights details"
  default     = {}
}