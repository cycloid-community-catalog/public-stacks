#
# Kapsule Cluster
#

resource "scaleway_k8s_cluster_beta" "cluster" {
  name        = var.cluster_name
  description = "${var.customer} ${var.project} Kapsule ${var.env} cluster"
  version     = var.cluster_version
  
  cni               = var.cni
  ingress           = var.ingress
  enable_dashboard  = var.enable_dashboard
  feature_gates     = var.feature_gates
  admission_plugins = var.admission_plugins

  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))

  auto_upgrade {
    enable                        = var.auto_upgrade
    maintenance_window_day        = var.maintenance_window_day
    maintenance_window_start_hour = var.maintenance_window_start_hour
  }

  autoscaler_config {
    disable_scale_down              = var.disable_scale_down
    scale_down_delay_after_add      = var.scale_down_delay_after_add
    scale_down_unneeded_time        = var.scale_down_unneeded_time
    estimator                       = var.estimator
    expander                        = var.expander
    ignore_daemonsets_utilization   = var.ignore_daemonsets_utilization
    balance_similar_node_groups     = var.balance_similar_node_groups
    expendable_pods_priority_cutoff = var.expendable_pods_priority_cutoff
  }
}