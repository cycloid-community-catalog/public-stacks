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

# AWS
variable "access_key" {
  description = "AWS IAM access key ID."
}

variable "secret_key" {
  description = "AWS IAM access secret key."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

# EKS
locals {
  eks_cluster_name = length(local.cluster_name) > 0 ? local.cluster_name : "${var.project}-${var.env}"
}