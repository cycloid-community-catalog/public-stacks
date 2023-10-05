#
# vNet outputs
#
output "rg_name" {
  description = "The resource group created hosting the worker resources"
  value       = module.cycloid-worker.rg_name
}

output "vnet_name" {
  description = "The ID for the created VPC"
  value       = module.cycloid-worker.vnet_name
}

#
# Instance outputs
#
output "vm_ip" {
  description = "The IP address of the worker instance"
  value       = module.cycloid-worker.vm_ip
}

output "vm_os_user" {
  description = "The username to use to connect to the instance via SSH."
  value       = module.cycloid-worker.vm_os_user
}