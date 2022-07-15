# Cycloid
variable "customer" {}
variable "env" {}
variable "project" {}


#
# Cloud provider
#

variable "azure_location" {
  description = "Azure location"
  default = "West Europe"
}

variable "rg_name" {
  description = "Resource group name"
  default = "cycloid-worker"
}


#
# Instance
#
variable "vm_instance_type" {
  description = "Instance type for the Cycloid worker"
  default     = "Standard_DS2_v2"
}

variable "vm_disk_size" {
  description = "Disk size for the Cycloid worker (Go)"
  default = "20"
}

variable "vm_os_user" {
  description = "Admin username to connect to instance via SSH"
  default     = "admin"
}

variable "keypair_public" {
  description = "The public SSH key, for SSH access to newly-created instances"
}


#
# Cycloid worker
#
variable "team_id" {
  description = "Cycloid team ID"
  default     = ""
}

variable "worker_key" {
  description = "Cycloid worker private key"
  default = ""
}


# Tags
variable "extra_tags" {
  default = {}
}

locals {
  standard_tags = {
    "cycloid" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}