# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}


# AWS variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  description = "AWS region where to create servers."
  default     = "eu-west-1"
}


#
# Instance
#
variable "vm_instance_type" {
  description = "Instance type for the Cycloid worker"
  default     = "t3.micro"
}

variable "vm_disk_size" {
  description = "Disk size for the Cycloid worker (Go)"
  default = "20"
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
