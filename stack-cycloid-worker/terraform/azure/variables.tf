# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}


# Azure variables
variable "azure_cred" {
  description = "The azure credential used to deploy the infrastructure. It contains subscription_id, tenant_id, client_id, and client_secret"
}
variable "azure_location" {
    default = "West Europe"
}
variable "rg_name" {
    default = ""
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
  default = "30"
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