# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}


# Azure variables
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_subscription_id" {}
variable "azure_tenant_id" {}
variable "azure_env" {
    default = "public"
}
variable "azure_location" {
    default = "West Europe"
}
variable "rg_name" {
    description = "Existing Resource Group where to create the resources."
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
  description = "The default admin user for the instance"
  default = "cycloid"
}

variable "keypair_public" {
  description = "The public SSH key, for SSH access to newly-created instances"
}


#
# Cycloid worker
#
variable "team_id" {
  description = "Cycloid team ID"
}

variable "worker_key" {
  description = "Cycloid worker private key"
}
