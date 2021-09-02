output "cluster_id" {
  description = "AKS Cluster ID."
  value       = azurerm_kubernetes_cluster.aks-cluster.id
}

output "cluster_name" {
  description = "AKS Cluster name."
  value       = azurerm_kubernetes_cluster.aks-cluster.name
}

output "cluster_public_fqdn" {
  description = "EKS Cluster public FQDN."
  value       = azurerm_kubernetes_cluster.aks-cluster.fqdn
}

output "cluster_private_fqdn" {
  description = "EKS Cluster private FQDN."
  value       = azurerm_kubernetes_cluster.aks-cluster.private_fqdn
}

output "cluster_host" {
  description = "EKS Cluster kubeconfig host."
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host
}

output "cluster_ca" {
  description = "AKS Cluster certificate authority."
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the AKS Cluster."
  value       = var.enable_rbac && var.rbac_use_active_directory ? azurerm_kubernetes_cluster.aks-cluster.kube_admin_config_raw : azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}