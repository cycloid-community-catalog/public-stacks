# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}

# vSphere variables
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "vsphere_allow_unverified_ssl"{
    default = true
}