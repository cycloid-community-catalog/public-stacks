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

variable cluster_id {
  type        = string
  description = "Kapsule Cluster ID."
}

variable cluster_name {
  type        = string
  description = "Kapsule Cluster given name."
}

#
# Nodes
#

variable node_pool_name {
  type        = string
  description = "Kapsule nodes pool given name."
  default     = "standard"
}

variable node_type {
  type        = string
  description = "The commercial type of the pool instances. Important: Updates to this field will recreate a new resource."
  default     = "GP1-XS"
}

variable node_count {
  type        = number
  description = "The size of the pool. Important: This field will only be used at creation if autoscaling is enabled."
  default     = 1
}

variable enable_autoscaling {
  type        = bool
  default     = false
  description = "Enables the autoscaling feature for this pool. Important: When enabled, an update of the size will not be taken into account."
}

variable node_autoscaling_min_size {
  type        = number
  description = "The minimum size of the pool, used by the autoscaling feature."
  default     = 1
}

variable node_autoscaling_max_size {
  type        = number
  description = "The maximum size of the pool, used by the autoscaling feature."
  default     = 10
}

variable enable_autohealing {
  type        = bool
  description = "Enables the autohealing feature for this pool."
  default     = true
}

variable container_runtime {
  type        = string
  description = "The container runtime of the pool. Important: Updates to this field will recreate a new resource."
  default     = "docker"
}

variable placement_group_id {
  type        = string
  description = "The placement group the nodes of the pool will be attached to. Important: Updates to this field will recreate a new resource."
  default     = ""
}

variable wait_for_pool_ready {
  type        = bool
  description = "Whether to wait for the pool to be ready."
  default     = true
}