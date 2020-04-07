# Put here a custom name for the EKS Cluster
# Otherwise `${var.project}-${var.env}` will be used
locals {
  cluster_name = ""
}

# By default this stack will create a dedicated VPC for the EKS Cluster
# as the default pod networking will be using this VPC and
# as some specific VPC and subnets tagging is required.
# @See:
# - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# - https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html
#
# If you want to manage the VPC used by the EKS Cluster elsewhere, comment
# the following `vpc` module and change all `module.vpc.` references to
# the matching required informations from your own setup.
#
module "vpc" {
  #####################################
  # Do not modify the following lines #
  source = "./module-vpc"

  project  = var.project
  env      = var.env
  customer = var.customer

  #####################################

  ###
  # General
  ###

  #. aws_zones (optional): {}
  #+ To use specific AWS Availability Zones.

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  ###
  # Networking
  ###

  #. vpc_cidr: 10.8.0.0/16
  #+ The CIDR of the VPC.
  vpc_cidr = "10.8.0.0/16"

  #. private_subnets (optional, list): ["10.8.0.0/24", "10.8.2.0/24", "10.8.4.0/24"]
  #+ The private subnets for the VPC.
  private_subnets = ["10.8.0.0/24", "10.8.2.0/24", "10.8.4.0/24"]

  #. public_subnets (optional, list): ["10.8.1.0/24", "10.8.3.0/24", "10.8.5.0/24"]
  #+ The public subnets for the VPC.
  public_subnets = ["10.8.1.0/24", "10.8.3.0/24", "10.8.5.0/24"]

  #. enable_dynamodb_endpoint (optional, bool): false
  #+ Should be true if you want to provision a DynamoDB endpoint to the VPC.
  #enable_dynamodb_endpoint = false

  #. enable_s3_endpoint (optional, bool): false
  #+ Should be true if you want to provision an S3 endpoint to the VPC.
  #enable_s3_endpoint = false

  #. bastion_sg_id (optional):
  #+ Security Group ID of the bastion to allow SSH access. Make sure the bastion VPC is peered.

  ###
  # Required (should probably not be touched)
  ###

  cluster_name = local.eks_cluster_name
}

module "eks" {
  #####################################
  # Do not modify the following lines #
  source = "./module-eks"

  project  = var.project
  env      = var.env
  customer = var.customer

  #####################################

  ###
  # General
  ###

  #. aws_zones (optional): {}
  #+ To use specific AWS Availability Zones.

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  ###
  # Networking
  ###

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id = module.vpc.vpc_id

  #. public_subnets_ids (required, array):
  #+ Amazon subnets IDs on which create each components.
  public_subnets_ids = module.vpc.public_subnets

  #. metrics_sg_allow (optional): ""
  #+ Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics. Make sure the prometheus VPC is peered.
  #metrics_sg_allow = "<prometheus-sg>"

  ###
  # Control plane
  ###

  #. cluster_version (optional): 1.14
  #+ EKS cluster version.
  cluster_version = "1.14"

  #. cluster_enabled_log_types (optional): ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  #+ EKS cluster enabled log types.

  #. control_plane_allowed_ips (optional): [] 
  #+ Allow Inbound IP CIDRs to access the Kubernetes API.

  ###
  # Required (should probably not be touched)
  ###

  cluster_name = local.eks_cluster_name
}

# You can duplicate this module to create mutiple EKS node groups.
# Make sure to change the `node_group_name` field accordingly.
module "eks-node" {
  #####################################
  # Do not modify the following lines #
  source = "./module-eks-node"

  project  = var.project
  env      = var.env
  customer = var.customer

  #####################################

  ###
  # General
  ###

  #. keypair_name (requiredl): cycloid
  #+ Name of an existing AWS SSH keypair to use to deploy EC2 instances.
  keypair_name = "cycloid"

  #. aws_zones (optional): {}
  #+ To use specific AWS Availability Zones.

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  ###
  # Networking
  ###

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id = module.vpc.vpc_id

  #. private_subnets_ids (required, array):
  #+ Amazon subnets IDs on which create each components.
  private_subnets_ids = module.vpc.private_subnets

  #. bastion_sg_allow (optional):
  #+ Amazon source security group ID which will be allowed to connect on nodes port 22 (SSH). Only if module.vpc.bastion_sg_id variable is set.
  #bastion_sg_allow = module.vpc.bastion_sg_allow

  #. metrics_sg_allow (optional): ""
  #+ Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics. Make sure the prometheus VPC is peered.
  #metrics_sg_allow = "<prometheus-sg>"

  ###
  # Nodes
  ###

  #. node_group_name (optional): standard
  #+ Node group given name.
  node_group_name = "standard"

  #. node_type (optional): c3.xlarge
  #+ Type of instance to use for node servers.
  node_type = "c3.xlarge"

  #. node_count (optional): 1
  #+ Desired number of node servers.
  node_count = "1"

  #. node_asg_min_size (optional): 1
  #+ Minimum number of node servers allowed in the Auto Scaling Group.

  #. node_asg_max_size (optional): 10
  #+ Maximum number of node servers allowed in the Auto Scaling Group.

  #. node_disk_type (optional): gp2
  #+ EKS nodes root disk type.

  #. node_disk_size (optional): 60
  #+ EKS nodes root disk size.

  #. node_ebs_optimized (optional): false
  #+ Should be true if the instance type is using EBS optimized volumes.

  #. node_launch_template_profile (optional): ondemand
  #+ EKS nodes profile, can be either `ondemand` or `spot`.

  #. node_spot_price (optional): 0.3
  #+ EKS nodes spot price when `node_market_type = spot`.

  #. node_enable_cluster_autoscaler_tags (optional): false
  #+ Should be true to add Cluster Autoscaler ASG tags.

  ###
  # Required (should probably not be touched)
  ###

  cluster_name                   = module.eks.cluster_name
  cluster_version                = module.eks.cluster_version
  node_iam_instance_profile_name = module.eks.node_iam_instance_profile_name
  control_plane_sg_id            = module.eks.control_plane_sg_id
  control_plane_endpoint         = module.eks.control_plane_endpoint
  control_plane_ca               = module.eks.control_plane_ca
}

#
# VPC Peering example
#

# resource "aws_vpc_peering_connection" "external_eks" {
#   peer_vpc_id = "<EXTERNAL-VPC-ID>"
#   vpc_id      = module.vpc.vpc_id
#   auto_accept = true

#   tags = {
#     Name         = "VPC Peering between `<EXTERNAL-VPC-NAME>` external VPC and the dedicated `${var.project}-${var.env}-eks` VPC"
#     "cycloid.io" = "true"
#     env          = var.env
#     project      = var.project
#     client       = var.customer
#   }
# }

# resource "aws_route" "external_eks_public" {
#   for_each = toset("<EXTERNAL-VPC-PUBLIC-ROUTE-TABLE-IDS>")

#   route_table_id            = each.value
#   destination_cidr_block    = module.vpc.vpc_cidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.infra_eks.id
# }

# resource "aws_route" "external_eks_private" {
#   for_each = toset("<EXTERNAL-VPC-PRIVATE-ROUTE-TABLE-IDS>")

#   route_table_id            = each.value
#   destination_cidr_block    = module.vpc.vpc_cidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.infra_eks.id
# }

# resource "aws_route" "eks_external_public" {
#   for_each = toset(module.vpc.public_route_table_ids)

#   route_table_id            = each.value
#   destination_cidr_block    = "<EXTERNAL-VPC-VPC-CIDR>"
#   vpc_peering_connection_id = aws_vpc_peering_connection.infra_eks.id
# }

# resource "aws_route" "eks_external_private" {
#   for_each = toset(module.vpc.private_route_table_ids)

#   route_table_id            = each.value
#   destination_cidr_block    = "<EXTERNAL-VPC-VPC-CIDR>"
#   vpc_peering_connection_id = aws_vpc_peering_connection.infra_eks.id
# }

# resource "aws_route53_zone_association" "vpc_private_external" {
#   zone_id = module.vpc.private_zone_id
#   vpc_id  = "<EXTERNAL-VPC-ID>"
# }

#
# Monitoring Security Group example
#

# resource "aws_security_group" "eks_allow_metrics_scraping" {
#   name        = "eks_allow_metrics_scraping"
#   description = "Allow prometheus server to scrape metrics"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port       = 9100
#     to_port         = 9100
#     protocol        = "tcp"
#     security_groups = ["<external-prometheus-security-group-id>"]
#     self            = false
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name         = "${var.project}-${var.env}-eks-allow-metrics-scraping"
#     "cycloid.io" = "true"
#     customer     = "${var.customer}"
#     project      = "${var.project}"
#     env          = "${var.env}"
#   }
# }

# output "eks_metrics_sg_allow" {
#   value = aws_security_group.eks_allow_metrics_scraping.id
# }
