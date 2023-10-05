#
# Resource Group outputs
#
output "rg_name" {
  description = "The name for the resource group"
  value       = data.azurerm_resource_group.avd.name
}

#
# AVD outputs
#
output "avd_application_group_name" {
  description = "The name for the Application Group"
  value       = azurerm_virtual_desktop_application_group.avd.name
}

output "avd_application_group_id" {
  description = "The ID for the Application Group"
  value       = azurerm_virtual_desktop_application_group.avd.id
}

output "avd_host_pool_name" {
  description = "The name for the Host Pool"
  value       = azurerm_virtual_desktop_host_pool.avd.name
}

output "avd_host_pool_id" {
  description = "The ID for the Host Pool"
  value       = azurerm_virtual_desktop_host_pool.avd.id
}

output "avd_workspace_name" {
  description = "The name for the Workspace"
  value       = azurerm_virtual_desktop_workspace.avd.name
}

output "avd_workspace_id" {
  description = "The ID for the Workspace"
  value       = azurerm_virtual_desktop_workspace.avd.id
}