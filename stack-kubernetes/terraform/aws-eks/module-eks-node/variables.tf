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

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

variable "keypair_name" {
  description = "AWS KeyPair name to use on EC2 instances."
  default     = "cycloid"
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

variable "private_subnets_ids" {
  description = "VPC private subnets IDs to use to create the EKS nodes."
  type        = list(string)
}

variable "bastion_sg_allow" {
  description = "Additionnal security group ID to assign to servers. Goal is to allow bastion server to connect on nodes port 22 (SSH). Make sure the bastion VPC is peered."
  default     = ""
}

variable "metrics_sg_allow" {
  description = "Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics. Make sure the prometheus VPC is peered."
  default     = ""
}

#
# Control plane
#

variable "cluster_name" {
  description = "EKS Cluster given name."
}

variable "cluster_version" {
  description = "EKS Cluster version for EKS nodes AMI"
}

variable "control_plane_endpoint" {
  description = "EKS Cluster endpoint."
}

variable "control_plane_ca" {
  description = "EKS Cluster certificate authority."
}

#
# Nodes
#

variable "node_iam_instance_profile_name" {
  description = "EKS nodes IAM instance profile name."
}

variable "node_sg_id" {
  description = "EKS nodes Security Group ID."
}

variable "node_group_name" {
  description = "EKS nodes group given name."
  default     = "standard"
}

variable "node_launch_template_profile" {
  description = "EKS nodes profile, can be either `ondemand` or `spot`."
  default     = "ondemand"
}

variable "node_launch_template_id" {
  default = ""
}

variable "node_launch_template_latest_version" {
  default = ""
}

variable "node_spot_request_type" {
  description = "EKS nodes spot request type when `node_market_type = spot`. Can be either `one-time`, `persistent` or left undefined."
  default     = ""
}

variable "node_spot_price" {
  description = "EKS nodes max spot price when `node_market_type = spot`. Undefined by default."
  default     = ""
}

variable "node_type" {
  description = "EKS nodes instance type."
  default     = "c5.xlarge"
}

variable "node_count" {
  description = "EKS nodes desired count."
  default     = 1
}

variable "node_asg_min_size" {
  description = "EKS nodes Auto Scaling Group minimum size."
  default     = 1
}

variable "node_asg_max_size" {
  description = "EKS nodes Auto Scaling Group maximum size."
  default     = 10
}

variable "node_update_min_in_service" {
  description = "Minimum EKS nodes in service during Auto Scaling Group rolling update."
  default     = 1
}

variable "node_associate_public_ip_address" {
  description = "Should be true if EIP address should be associated to EKS nodes."
  default     = false
}

variable "node_disk_type" {
  description = "EKS nodes root disk type."
  default     = "gp2"
}

variable "node_disk_size" {
  description = "EKS nodes root disk size."
  default     = "60"
}

variable "node_ebs_optimized" {
  description = "Should be true if the instance type is using EBS optimized volumes."
  default     = true
}

locals {
  cluster_autoscaler_tags = {
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  }
}

variable "node_enable_cluster_autoscaler_tags" {
  description = "Should be true to add Cluster Autoscaler ASG tags."
  default     = false
}
