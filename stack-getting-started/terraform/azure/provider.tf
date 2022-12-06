variable "customer" {}
variable "project" {}
variable "env" {}

terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "~> 1.42.0"
    }
  }
}
# Azure
provider "azurerm" {
  environment     = var.azure_env
  client_id       = var.azure_cred.client_id
  client_secret   = var.azure_cred.client_secret
  subscription_id = var.azure_cred.subscription_id
  tenant_id       = var.azure_cred.tenant_id
}

# Azure
variable "azure_cred" {}
# contains:
# .subscription_id
# .tenant_id
# .client_id
# .client_secret

variable "azure_env" {
  default = "public"
}

variable "azure_resource_group_name" {}

variable "azure_location" {
  default = "francecentral"
}
