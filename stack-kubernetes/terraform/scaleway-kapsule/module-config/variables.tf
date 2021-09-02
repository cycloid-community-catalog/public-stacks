#
# General
#

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

variable "cluster_name" {
  description = "Scaleway Cluster given name."
  default     = ""
}

variable "placement_group_name"{
  description = "The placement group name. It groups nodes of the pool will be attached to. Important: Updates to this field will recreate a new resource."
  default = ""
} 

variable "scw_region" {
  type        = string
  description = "Scaleway region to create resources."
  default     = "fr-par"
}

variable "scw_zone_id" {
  type        = string
  description = "Scaleway region's zone ID to create resources."
  default     = "1"
}

# Scaleway
locals {
  scaleway_cluster_name = length(var.cluster_name) > 0 ? var.cluster_name : "${var.project}-${var.env}"
  scw_zone = "${var.scw_region}-${var.scw_zone_id}"
}