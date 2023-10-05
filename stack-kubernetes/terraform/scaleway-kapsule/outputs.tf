#
# Scaleway
#

output "scw_region" {
  description = "Scaleway region where the resources were created."
  value       = var.scw_region
}

output "scw_zone" {
  description = "Scaleway zone where the resources were created."
  value       = local.scw_zone
}

#
# Kapsule Cluster
#

output "cluster_id" {
  description = "Kapsule Cluster ID."
  value       = module.kapsule.cluster_id
}

output "cluster_name" {
  description = "Kapsule Cluster name."
  value       = module.kapsule.cluster_name
}

output "cluster_version" {
  description = "Kapsule Cluster version."
  value       = module.kapsule.cluster_version
}

output "cluster_wildcard_dns" {
  description = "The DNS wildcard that points to all ready nodes."
  value       = module.kapsule.cluster_wildcard_dns
}

output "cluster_status" {
  description = "Kapsule Cluster status of the Kubernetes cluster."
  value       = module.kapsule.cluster_status
}

output "cluster_upgrade_available" {
  description = "Set to `true` if a newer Kubernetes version is available."
  value       = module.kapsule.cluster_upgrade_available
}

output "control_plane_endpoint" {
  description = "Kapsule Cluster URL of the Kubernetes API server."
  value       = module.kapsule.control_plane_endpoint
}

output "control_plane_host" {
  description = "Kapsule Cluster URL of the Kubernetes API server."
  value       = module.kapsule.control_plane_host
}

output "control_plane_ca" {
  description = "Kapsule Cluster CA certificate of the Kubernetes API server."
  value       = module.kapsule.control_plane_ca
}

output "control_plane_token" {
  description = "Kapsule Cluster token to connect to the Kubernetes API server."
  value       = module.kapsule.control_plane_token
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the Kapsule cluster."
  value       = module.kapsule.kubeconfig
}

#
# Kapsule Node Pool
#

output "node_pool_id" {
  description = "Kapsule node pool ID."
  value       = module.node_pool.node_pool_id
}

output "node_pool_status" {
  description = "Kapsule node pool status."
  value       = module.node_pool.node_pool_status
}

output "node_pool_version" {
  description = "Kapsule node pool version."
  value       = module.node_pool.node_pool_version
}

output "node_pool_current_size" {
  description = "Kapsule node pool current size."
  value       = module.node_pool.node_pool_current_size
}

output "node_pool_nodes" {
  description = "Kapsule node pool nodes informations."
  value       = module.node_pool.node_pool_nodes
}

output "node_pool_public_ips" {
  description = "Kapsule node pool public IPs."
  value       = module.node_pool.node_pool_public_ips
}

output "node_pool_public_ipv6s" {
  description = "Kapsule node pool public IPv6s."
  value       = module.node_pool.node_pool_public_ipv6s
}