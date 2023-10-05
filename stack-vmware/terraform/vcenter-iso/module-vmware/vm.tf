data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "iso_datastore" {
  name          = var.vsphere_datastore_iso
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_cpu
  memory   = var.vm_memory

  guest_id = var.vm_guest_id

  wait_for_guest_net_timeout = 0
  wait_for_guest_net_routable = false

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0" # Increase the number for each new disk
    size  = var.vm_disk_size
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = var.vm_iso
  }
  
}