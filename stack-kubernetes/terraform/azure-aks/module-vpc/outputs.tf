output "vnet_id" {
  description = "AKS Cluster dedicated vNet ID."
  value       = module.azure-network.vnet_id
}

output "vnet_name" {
  description = "AKS Cluster dedicated vNet name."
  value       = module.azure-network.vnet_name
}

output "vnet_location" {
  description = "AKS Cluster dedicated vNet location."
  value       = module.azure-network.vnet_location
}

output "vnet_subnet_ids" {
  description = "AKS Cluster dedicated vNet subnet IDs."
  value       = {
    for subnet in azurerm_subnet.aks:
    subnet.name => subnet.id
  }
}

output "vnet_address_space" {
  description = "AKS Cluster dedicated vNet address space."
  value       = module.azure-network.vnet_address_space
}

output "nodes_sg_allow" {
  description = "AKS Cluster dedicated vNet security group to allow SSH and metrics access to instances."
  value       = azurerm_network_security_group.aks-nodes.id
}