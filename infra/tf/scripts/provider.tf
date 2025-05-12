

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  environment     = "public"
  #subscription_id = var.subscription_id
  partner_id      = "b1a9fe1d-a5e7-4e8c-9ad2-ea4701dec00b"
  #tenant_id       = var.tenant_id
  features {}
}
