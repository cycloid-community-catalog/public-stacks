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
  description = "GKE Cluster given name."
  default     = ""
}

# GKE
locals {
  gke_cluster_name = length(var.cluster_name) > 0 ? var.cluster_name : "${var.project}-${var.env}"
}