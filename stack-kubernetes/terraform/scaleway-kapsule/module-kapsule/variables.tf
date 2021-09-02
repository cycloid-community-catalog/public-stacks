#
# Cycloid
#

variable project {
  type        = string
  description = "Cycloid project name."
}

variable env {
  type        = string
  description = "Cycloid environment name."
}

variable customer {
  type        = string
  description = "Cycloid customer name."
}

#
# Scaleway
#

variable scw_region {
  type        = string
  description = "Scaleway region to create resources."
}

variable scw_zone {
  type        = string
  description = "Scaleway region's zone to create resources."
}

variable extra_tags {
  type        = list
  description = "Extra tags to add to the resources."
  default     = []
}

locals {
  standard_tags = [
    "cycloid.io=true",
    "env=${var.env}",
    "project=${var.project}",
    "customer=${var.customer}",
  ]
  merged_tags = compact(concat(local.standard_tags, var.extra_tags))
}

#
# Control plane
#

variable cluster_name {
  type        = string
  description = "Kapsule Cluster given name."
}

variable cluster_version {
  type        = string
  description = "Kapsule Cluster version to use."
  default     = "1.19"
}

variable cni {
  type        = string
  default     = "cilium"
  description = "The Container Network Interface (CNI) for the Kubernetes cluster (either `cilium`, `calico`, `weave` or `flannel`)."
}

variable ingress {
  type        = string
  default     = "nginx"
  description = "The ingress controller to be deployed on the Kubernetes cluster (either `nginx`, `traefik` or `traefik2`)."
}

variable enable_dashboard {
  type        = bool
  default     = true
  description = "Enables the Kubernetes dashboard for the Kubernetes cluster."
}

variable feature_gates {
  type        = list
  default     = []
  description = "The list of feature gates to enable on the cluster."
}

variable admission_plugins {
  type        = list
  default     = []
  description = "The list of admission plugins to enable on the cluster."
}

variable auto_upgrade {
  type        = bool
  default     = true
  description = "Set to `true` to enable Kubernetes patch version auto upgrades. Important: When enabling auto upgrades, the `cluster_version` variable take a minor version like x.y (ie 1.18)."
}

variable maintenance_window_day {
  type        = string
  default     = "tuesday"
  description = "The day of the auto upgrade maintenance window (`monday` to `sunday`, or `any`)."
}

variable maintenance_window_start_hour {
  type        = number
  default     = 5
  description = "The start hour (UTC) of the 2-hour auto upgrade maintenance window (`0` to `23`)."
}

variable disable_scale_down {
  type        = bool
  default     = false
  description = "Disables the scale down feature of the autoscaler."
}

variable scale_down_delay_after_add {
  type        = string
  default     = "10m"
  description = "How long after scale up that scale down evaluation resumes."
}

variable scale_down_unneeded_time {
  type        = string
  default     = "10m"
  description = "How long a node should be unneeded before it is eligible for scale down."
}

variable estimator {
  type        = string
  default     = "binpacking"
  description = "Type of resource estimator to be used in scale up."
}

variable expander {
  type        = string
  default     = "random"
  description = "Type of node group expander to be used in scale up."
}

variable ignore_daemonsets_utilization {
  type        = bool
  default     = true
  description = "Ignore DaemonSet pods when calculating resource utilization for scaling down."
}

variable balance_similar_node_groups {
  type        = bool
  default     = true
  description = "Detect similar node groups and balance the number of nodes between them."
}

variable expendable_pods_priority_cutoff {
  type        = string
  default     = "-10"
  description = "Pods with priority below cutoff will be expendable. They can be killed without any consideration during scale down and they don't cause scale up. Pods with null priority (PodPriority disabled) are non expendable."
}