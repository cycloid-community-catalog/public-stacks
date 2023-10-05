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
  description = "EKS Cluster given name."
  default     = ""
}

# EKS
locals {
  eks_cluster_name = length(var.cluster_name) > 0 ? var.cluster_name : "${var.project}-${var.env}"
}