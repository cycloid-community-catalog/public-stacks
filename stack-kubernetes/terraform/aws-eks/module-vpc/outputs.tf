output "vpc_id" {
  description = "EKS Cluster dedicated VPC ID."
  value       = module.aws-vpc.vpc_id
}

output "vpc_cidr" {
  description = "EKS Cluster dedicated VPC CIDR."
  value       = module.aws-vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "EKS Cluster dedicated VPC private subnets."
  value       = module.aws-vpc.private_subnets
}

output "public_subnets" {
  description = "EKS Cluster dedicated VPC public subnets."
  value       = module.aws-vpc.public_subnets
}

output "public_route_table_ids" {
  description = "EKS Cluster dedicated VPC public route table IDs."
  value       = module.aws-vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "EKS Cluster dedicated VPC private route table IDs."
  value       = module.aws-vpc.private_route_table_ids
}

output "private_zone_id" {
  description = "EKS Cluster dedicated VPC private zone ID."
  value       = aws_route53_zone.vpc_private.zone_id
}

output "private_zone_name" {
  description = "EKS Cluster dedicated VPC private zone name."
  value       = aws_route53_zone.vpc_private.name
}