# VPC
output "vpc_id" {
  description = "EKS Cluster VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "EKS Cluster dedicated VPC CIDR."
  value       = module.vpc.vpc_cidr
}


output "public_subnets" {
  description = "EKS Cluster VPC public subnets."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "EKS Cluster VPC private subnets."
  value       = module.vpc.private_subnets
}

output "public_route_table_ids" {
  description = "EKS Cluster dedicated VPC public route table IDs."
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "EKS Cluster dedicated VPC private route table IDs."
  value       = module.vpc.private_route_table_ids
}

output "private_zone_id" {
  description = "EKS Cluster dedicated VPC private zone ID."
  value       = module.vpc.private_zone_id
}

output "private_zone_name" {
  description = "EKS Cluster dedicated VPC private zone name."
  value       = module.vpc.private_zone_name
}

output "aws_region" {
  description = "EKS Region."
  value       = var.aws_region
}

# EKS Cluster
output "cluster_name" {
  description = "EKS Cluster name."
  value       = module.eks.cluster_name
}

output "cluster_version" {
  description = "EKS Cluster version."
  value       = module.eks.cluster_version
}

output "cluster_platform_version" {
  description = "EKS Cluster plateform version."
  value       = module.eks.cluster_platform_version
}

output "control_plane_sg_id" {
  description = "EKS Cluster Security Group ID."
  value       = module.eks.control_plane_sg_id
}

output "control_plane_endpoint" {
  description = "EKS Cluster endpoint."
  value       = module.eks.control_plane_endpoint
}

output "control_plane_ca" {
  description = "EKS Cluster certificate authority."
  value       = module.eks.control_plane_ca
}

output "control_plane_openid_issuer_url" {
  description = "EKS Cluster OpenID Connect issuer URL."
  value       = module.eks.control_plane_openid_issuer_url
}

output "node_iam_role_arn" {
  description = "EKS nodes IAM role ARN."
  value       = module.eks.node_iam_role_arn
}

output "node_iam_instance_profile_name" {
  description = "EKS nodes IAM instance profile name."
  value       = module.eks.node_iam_instance_profile_name
}

output "node_sg_id" {
  description = "EKS nodes Security Group ID."
  value       = module.eks.node_sg_id
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the EKS cluster."
  value       = module.eks.kubeconfig
}
