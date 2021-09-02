output "cluster_name" {
  description = "Scaleway Cluster given name."
  value       = local.scaleway_cluster_name
}

output "scw_zone" {
  description = "Scaleway zone made of region and the zone id."
  value       = local.scw_zone
}

output "placement_group_id" {
  description = "Scaleway zone made of region and the zone id."
  value       = scaleway_instance_placement_group.placement_group.id
}