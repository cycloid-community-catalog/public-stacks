# Cycloid requirements
variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

# GCP
variable "gcp_project" {
  description = "GCP project to launch services."
  default     = "kubernetes-gke"
}

variable "gcp_region" {
  description = "GCP region to launch services."
  default     = "europe-west1"
}

# GKE
# Put here a custom name for the EKS Cluster
# Otherwise `${var.project}-${var.env}` will be used
variable "cluster_name" {
  description = "GKE Cluster given name."
  default     = ""
}