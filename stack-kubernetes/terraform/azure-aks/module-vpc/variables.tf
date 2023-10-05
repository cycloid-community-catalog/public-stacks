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

variable "resource_group_name" {
  description = "Azure Resource Group to use."
}

variable "location" {
  description = "Specific Azure Location to use."
}

variable "extra_tags" {
  description = "Extra tags to add to all resources."
  default     = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

#
# Networking
#

variable "address_space" {
  description = "The virtual network address space."
  default     = "10.8.0.0/14"
}

variable "subnets" {
  description = "The private subnets for the VPC."
  default     = {
    "nodes" = "10.8.0.0/16",
    "pods"  = "10.9.0.0/16",
    # Azure don't like Terraform to create the service subnet used by AKS so we should skip it
    # "services" = "10.10.0.0/16",
    "loadbalancers" = "10.11.0.0/16",
  }
}

variable "ssh_allowed_ips" {
  description = "Allow Inbound IP CIDRs to access the instances via SSH."
  default     = ["*"]
}

variable "metrics_allowed_ips" {
  description = "Allow Inbound IP CIDRs to access the instances on the metrics endpoint."
  default     = ["*"]
}