# vpc
output "vnet_id" {
  description = "AKS Cluster dedicated vNet ID."
  value       = module.vpc.vnet_id
}

output "vnet_name" {
  description = "AKS Cluster dedicated vNet name."
  value       = module.vpc.vnet_name
}

output "vnet_location" {
  description = "AKS Cluster dedicated vNet location."
  value       = module.vpc.vnet_location
}

output "vnet_subnet_ids" {
  description = "AKS Cluster dedicated vNet subnet IDs."
  value       = module.vpc.vnet_subnet_ids
}

output "vnet_address_space" {
  description = "AKS Cluster dedicated vNet address space."
  value       = module.vpc.vnet_address_space
}

output "nodes_sg_allow" {
  description = "AKS Cluster dedicated vNet security group to allow SSH and metrics access to instances."
  value       = module.vpc.nodes_sg_allow
}


# AKS Cluster
output "cluster_id" {
  description = "AKS Cluster ID."
  value       = module.aks.cluster_id
}

output "cluster_name" {
  description = "AKS Cluster name."
  value       = module.aks.cluster_name
}

output "cluster_public_fqdn" {
  description = "AKS Cluster public FQDN."
  value       = module.aks.cluster_public_fqdn
}

output "cluster_private_fqdn" {
  description = "AKS Cluster private FQDN."
  value       = module.aks.cluster_private_fqdn
}

output "cluster_host" {
  description = "AKS Cluster kubeconfig host."
  value       = module.aks.cluster_host
}

output "cluster_ca" {
  description = "AKS Cluster certificate authority."
  value       = module.aks.cluster_ca
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the AKS Cluster."
  value       = module.aks.kubeconfig
}