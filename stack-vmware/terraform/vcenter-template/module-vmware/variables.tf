# Cycloid
variable "customer" {}
variable "env" {}
variable "project" {}

#
# vSphere
#
variable "vsphere_datacenter" {
  description = "Datacenter where to create the virtual machine"
  default     = "dc1"
}

variable "vsphere_datastore" {
  description = "Datastore where to create the virtual machine"
  default     = "datastore1"
}

variable "vsphere_cluster" {
  description = "Cluster where to create the virtual machine"
  default     = "cluster1"
}

variable "vsphere_template" {
  description = "Virtual machine template"
  default     = "debian-9"
}

variable "vsphere_network" {
  description = "Network where to create the virtual machine"
  default     = "VM Network"
}


#
# VM
#

variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "($ organization_canonical $)-($ project $)-($ environment $)-vm"
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