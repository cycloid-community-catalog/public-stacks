# Cycloid resources
variable "customer" {}
variable "env" {}
variable "project" {}

#
# vSphere resources
#
variable "vsphere_datacenter" {
  description = "Datacenter where to create the virtual machine"
  default     = "dc1"
}

variable "vsphere_datastore" {
  description = "Datastore where to create the virtual machine"
  default     = "datastore1"
}

variable "vsphere_datastore_iso" {
  description = "Datastore where ISOs are stored"
  default     = "datastore1"
}

variable "vsphere_cluster" {
  description = "Cluster where to create the virtual machine"
  default     = "cluster1"
}

variable "vsphere_network" {
  description = "Network where to create the virtual machine"
  default     = "VM Network"
}


#
# VM resources
#
variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "($ organization_canonical $)-($ project $)-($ environment $)-vm"
}

variable "vm_guest_id" {
  description = "The guest ID for the operating system type"
  default = "otherGuest64"
}

variable "vm_cpu" {
  description = "Number of vCPU allocated to the virtual machine"
  default     = "2"
}

variable "vm_memory" {
  description = "Memory allocated to the virtual machine (Mo)"
  default     = "2048"
}

variable "vm_disk_size" {
  description = "Disk size allocated to the virtual machine (Go)"
  default = "20"
}

variable "vm_iso" {
  description = "Path to ISO file needed to bootstrap the virtual machine."
  default = "ISOs/debian-9.13.0-amd64-netinst.iso"
}