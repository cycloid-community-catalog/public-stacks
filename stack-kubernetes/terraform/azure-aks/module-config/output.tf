output "cluster_name" {
  description = "EKS Cluster given name."
  value       = local.aks_cluster_name
}

output "azurerm_resource_group_name" {
  description = "Azure Resource Group given name."
  value       = azurerm_resource_group.rg_aks.name
}

output "azurerm_resource_group_location" {
  description = "Azure Resource Location given name."
  value       = azurerm_resource_group.rg_aks.location
}