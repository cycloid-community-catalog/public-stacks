#
# General
#

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

variable "cluster_name" {
  description = "AKS Cluster given name."
  default     = ""
}

variable "resource_group_name" {
  description = "AKS Resource Group Name."
  default     = ""
}

variable "azure_location" {
  description = "Azure location to use."
  default     = "West Europe"
}

# AKS
locals {
  aks_cluster_name = length(var.cluster_name) > 0 ? var.cluster_name : "${var.project}-${var.env}"
  aks_resource_group_name = length(var.resource_group_name) > 0 ? var.resource_group_name : "${var.project}-${var.env}-aks"
}