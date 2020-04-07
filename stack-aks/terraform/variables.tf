# Cycloid requirements
variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

# Azure
variable "azure_client_id" {
  description = "Azure client ID to use."
}

variable "azure_client_secret" {
  description = "Azure client Secret to use."
}

variable "azure_subscription_id" {
  description = "Azure subscription ID to use."
}

variable "azure_tenant_id" {
  description = "Azure tenant ID to use."
}

variable "azure_env" {
  description = "Azure environment to use. Can be either `public`, `usgovernment`, `german` or `china`."
  default     = "public"
}

variable "azure_location" {
  description = "Azure location to use."
  default     = "West Europe"
}

# AKS
locals {
  aks_cluster_name = length(local.cluster_name) > 0 ? lower(local.cluster_name) : lower("${var.project}-${var.env}")
}

variable "aks_service_principal_client_id" {
  description = "The Client ID for the Service Principal used by the AKS cluster."
}

variable "aks_service_principal_client_secret" {
  description = "The Client Secret for the Service Principal used by the AKS cluster."
}