# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}


# GCP variables
variable "gcp_project" {}
variable "gcp_region" {
  description = "GCP region where to create servers."
  default     = "europe-west1"
}


#
# Instance
#
variable "vm_machine_type" {
  description = "Machine type for the Cycloid worker"
  default     = "n2-standard-2"
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
