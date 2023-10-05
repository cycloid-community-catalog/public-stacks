# Cycloid
variable "customer" {}
variable "env" {}
variable "project" {}

variable "app_group_type" {
  description = "The type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups."
  default     = "Desktop"
}

variable "host_pool_type" {
  description = "The type of the Virtual Desktop Host Pool. Valid options are Personal or Pooled. Changing the type forces a new resource to be created."
  default     = "Personal"
}

variable "host_pool_expiration_date" {
  description = "A valid RFC3339Time for the expiration of the token (between 1 hour and 30 days from now). For example: 2022-01-01T23:40:52Z."
  default     = ""
}

variable "host_pool_lb_type" {
  description = "TBreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold."
  default     = "DepthFirst"
}

variable "host_pool_max_sessions" {
  description = "Maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled."
  default     = 16
}

variable "rg_name" {
  description = "The name of the existing resource group where the resources will be deployed."
  default     = ""
}


# Tags
variable "extra_tags" {
  default = {}
}

locals {
  standard_tags = {
    "cycloid"    = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}