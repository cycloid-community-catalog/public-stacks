#
# Node Pool
#

resource "scaleway_k8s_pool_beta" "nodes" {
  cluster_id = var.cluster_id
  name       = "${var.cluster_name}-${var.node_pool_name}"
  node_type  = var.node_type
  size       = var.node_count

  autoscaling = var.enable_autoscaling
  min_size    = var.node_autoscaling_min_size
  max_size    = var.node_autoscaling_max_size

  autohealing         = var.enable_autohealing
  container_runtime   = var.container_runtime
  placement_group_id  = var.placement_group_id
  wait_for_pool_ready = var.wait_for_pool_ready

  tags = compact(concat(local.merged_tags, [
    "role=node-pool"
  ]))
}