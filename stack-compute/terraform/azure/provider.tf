variable "organization" {}
variable "project" {}
variable "env" {}
variable "component" {}

# Azure
provider "azurerm" {
  environment     = var.azure_env
  client_id       = var.azure_cred.client_id
  client_secret   = var.azure_cred.client_secret
  subscription_id = var.azure_cred.subscription_id
  tenant_id       = var.azure_cred.tenant_id
  features {}
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

variable "azure_location" {
  default = "francecentral"
}

variable "os_admin_password" {}
