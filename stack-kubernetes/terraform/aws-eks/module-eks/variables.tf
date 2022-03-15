#
# General
#

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "aws_zones" {
  description = "To use specific AWS Availability Zones."
  default     = []
}

locals {
  aws_availability_zones = length(var.aws_zones) > 0 ? var.aws_zones : data.aws_availability_zones.available.names
}

data "aws_caller_identity" "current" {}

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

variable "extra_tags" {
  description = "Extra tags to add to all resources."
  default     = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

#
# Networking
#

variable "vpc_id" {
  description = "VPC ID used to create the EKS Cluster."
}

variable "public_subnets_ids" {
  description = "VPC public subnets IDs to use to create the EKS Cluster."
  type        = list(string)
}

variable "metrics_sg_allow" {
  description = "Metrics Security Group ID to allow prometheus scraping."
  default     = ""
}

#
# Control plane
#

variable "cluster_name" {
  description = "EKS Cluster given name."
}

variable "cluster_version" {
  description = "EKS Cluster version to use."
  default     = "1.16"
}

variable "cluster_enabled_log_types" {
  description = "EKS Cluster log types to forward to CloudWatch."
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "control_plane_allowed_ips" {
  description = "Allow Inbound IP CIDRs to access the Kubernetes API."
  default     = ["0.0.0.0/0"]
}

locals {
  k8s_eks_admin_iam_role_arn = var.eks_admin_iam_role_arn != "" ? var.eks_admin_iam_role_arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin"
}

variable "eks_admin_iam_role_arn" {
  description = "AWS IAM role ARN to map as system:masters within the Kubernetes cluster. By default, a default arbitrary role called 'admin' will be allowed."
  default     = ""
}

