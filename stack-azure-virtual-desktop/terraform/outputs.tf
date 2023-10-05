#
# Resource Group outputs
#
output "rg_name" {
  description = "The name for the resource group"
  value       = module.avd.rg_name
}

#
# AVD ouiputs
#
output "avd_application_group_name" {
  description = "The name for the Application Group"
  value       = module.avd.avd_application_group_name
}

output "avd_application_group_id" {
  description = "The ID for the Application Group"
  value       = module.avd.avd_application_group_id
}

output "avd_host_pool_name" {
  description = "The name for the Host Pool"
  value       = module.avd.avd_host_pool_name
}

output "avd_host_pool_id" {
  description = "The ID for the Host Pool"
  value       = module.avd.avd_host_pool_id
}

output "avd_workspace_name" {
  description = "The name for the Workspace"
  value       = module.avd.avd_workspace_name
}

output "avd_workspace_id" {
  description = "The ID for the Workspace"
  value       = module.avd.avd_workspace_id
}