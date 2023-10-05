#
# Node pool
#

resource "azurerm_kubernetes_cluster_node_pool" "aks-nodes" {
  name                  = lower(substr(var.node_pool_name, 0, 12))
  kubernetes_cluster_id = var.cluster_id
  vm_size               = var.node_size
  node_count            = var.node_count

  enable_auto_scaling = var.enable_auto_scaling
  max_count           = var.node_max_count
  min_count           = var.node_min_count

  availability_zones    = length(var.node_availability_zones) > 0 ? var.node_availability_zones : null
  enable_node_public_ip = var.enable_node_public_ip
  max_pods              = var.node_max_pods
  node_taints           = var.node_taints
  os_disk_size_gb       = var.node_disk_size
  os_type               = var.node_os_type
  vnet_subnet_id        = var.network_subnet_id
}