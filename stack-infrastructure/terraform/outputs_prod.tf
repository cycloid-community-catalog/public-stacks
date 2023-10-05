output "prod_bastion_sg_allow" {
  description = "security group ID tp allow SSH traffic from the bastion to the prod instances"
  value       = module.infrastructure.prod_bastion_sg_allow
}

output "prod_vpc_id" {
  description = "The VPC ID for the prod VPC"
  value       = module.infrastructure.prod_vpc_id
}

output "prod_vpc_cidr" {
  description = "The CIDR for the prod VPC"
  value       = module.infrastructure.prod_vpc_cidr
}

output "prod_public_route_table_ids" {
  description = "The public route table IDs for the prod VPC"
  value       = module.infrastructure.prod_public_route_table_ids
}

output "prod_private_route_table_ids" {
  description = "The private route table IDs for the prod VPC"
  value       = module.infrastructure.prod_private_route_table_ids
}

output "prod_private_subnets" {
  description = "The private subnets for the prod VPC"
  value       = module.infrastructure.prod_private_subnets
}

output "prod_public_subnets" {
  description = "The public subnets for the prod VPC"
  value       = module.infrastructure.prod_public_subnets
}

output "prod_elasticache_subnets" {
  description = "The elasticache subnets for the prod VPC"
  value       = module.infrastructure.prod_elasticache_subnets
}

output "prod_elasticache_subnet_group" {
  description = "The elasticache subnet group for the prod VPC"
  value       = module.infrastructure.prod_elasticache_subnet_group
}

output "prod_rds_subnets" {
  description = "The RDS subnets for the prod VPC"
  value       = module.infrastructure.prod_rds_subnets
}

output "prod_rds_subnet_group" {
  description = "The RDS subnet group for the prod VPC"
  value       = module.infrastructure.prod_rds_subnet_group
}

output "prod_redshift_subnets" {
  description = "The redshift subnets for the prod VPC"
  value       = module.infrastructure.prod_redshift_subnets
}

output "prod_redshift_subnet_group" {
  description = "The Redshift subnet group for the prod VPC"
  value       = module.infrastructure.prod_redshift_subnet_group
}

output "prod_private_zone_id" {
  description = "Route53 private zone ID for the prod VPC"
  value       = module.infrastructure.prod_private_zone_id
}

output "prod_rds_parameters-mysql57" {
  description = "RDS db parameters ID for the prod VPC"
  value       = module.infrastructure.prod_rds_parameters-mysql57
}

