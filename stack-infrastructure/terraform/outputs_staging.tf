output "staging_bastion_sg_allow" {
  description = "security group ID tp allow SSH traffic from the bastion to the staging instances"
  value       = module.infrastructure.staging_bastion_sg_allow
}

output "staging_vpc_id" {
  description = "The VPC ID for the staging VPC"
  value       = module.infrastructure.staging_vpc_id
}

output "staging_vpc_cidr" {
  description = "The CIDR for the staging VPC"
  value       = module.infrastructure.staging_vpc_cidr
}

output "staging_public_route_table_ids" {
  description = "The public route table IDs for the staging VPC"
  value       = module.infrastructure.staging_public_route_table_ids
}

output "staging_private_route_table_ids" {
  description = "The private route table IDs for the staging VPC"
  value       = module.infrastructure.staging_private_route_table_ids
}

output "staging_private_subnets" {
  description = "The private subnets for the staging VPC"
  value       = module.infrastructure.staging_private_subnets
}

output "staging_public_subnets" {
  description = "The public subnets for the staging VPC"
  value       = module.infrastructure.staging_public_subnets
}

output "staging_elasticache_subnets" {
  description = "The elasticache subnets for the staging VPC"
  value       = module.infrastructure.staging_elasticache_subnets
}

output "staging_elasticache_subnet_group" {
  description = "The elasticache subnet group for the staging VPC"
  value       = module.infrastructure.staging_elasticache_subnet_group
}

output "staging_rds_subnets" {
  description = "The RDS subnets for the staging VPC"
  value       = module.infrastructure.staging_rds_subnets
}

output "staging_rds_subnet_group" {
  description = "The RDS subnet group for the staging VPC"
  value       = module.infrastructure.staging_rds_subnet_group
}

output "staging_redshift_subnets" {
  description = "The redshift subnets for the staging VPC"
  value       = module.infrastructure.staging_redshift_subnets
}

output "staging_redshift_subnet_group" {
  description = "The Redshift subnet group for the staging VPC"
  value       = module.infrastructure.staging_redshift_subnet_group
}

output "staging_private_zone_id" {
  description = "Route53 private zone ID for the staging VPC"
  value       = module.infrastructure.staging_private_zone_id
}

output "staging_rds_parameters-mysql57" {
  description = "RDS db parameters ID for the staging VPC"
  value       = module.infrastructure.staging_rds_parameters-mysql57
}

