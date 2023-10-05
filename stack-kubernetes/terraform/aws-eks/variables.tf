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
# Put here a custom name for the EKS Cluster
# Otherwise `${var.project}-${var.env}` will be used
variable "cluster_name" {
  description = "EKS Cluster given name."
  default     = ""
}