#
# Azure Infra outputs
#
output "vnet_name" {
  description = "The name for the virtual network"
  value       = azurerm_virtual_network.cycloid-worker.name
}

output "rg_name" {
  description = "The name for the resource group"
  value       = data.azurerm_resource_group.cycloid-worker.name
}

#
# Instance outputs
#
output "vm_ip" {
  description = "The IP address of the worker instance"
  value       = azurerm_linux_virtual_machine.cycloid-worker.public_ip_address
}

output "vm_os_user" {
  description = "Admin username to connect to instance via SSH"
  value       = var.vm_os_user
}