resource_groups = {
  resource_group_1 = {
    name     = "#{resourceGroupPrefix}#-#{env}#"
    location = "#{location}#"
    tags = {
      created_by  = "#{requestorName}#"
      contact_dl  = "#{requestorEmail}#"
      Application = "Terraform Test"
    }
  }
}
