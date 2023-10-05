output "keypair_name" {
  description = "The deployment keypair name"
  value       = module.infrastructure.keypair_name
}

output "bastion_ip" {
  description = "The EIP attached to the bastion EC2 server"
  value       = module.infrastructure.bastion_ip
}

output "bastion_sg" {
  description = "The bastion security group ID."
  value       = module.infrastructure.bastion_sg
}

output "infra_vpc_id" {
  description = "The VPC ID for the infra VPC"
  value       = module.infrastructure.infra_vpc_id
}

output "infra_vpc_cidr" {
  description = "The CIDR for the infra VPC"
  value       = module.infrastructure.infra_vpc_cidr
}

output "infra_public_route_table_ids" {
  description = "The public route table IDs for the infra VPC"
  value       = module.infrastructure.infra_public_route_table_ids
}

output "infra_private_route_table_ids" {
  description = "The private route table IDs for the infra VPC"
  value       = module.infrastructure.infra_private_route_table_ids
}

output "infra_private_subnets" {
  description = "The private subnets for the infra VPC"
  value       = module.infrastructure.infra_private_subnets
}

output "infra_public_subnets" {
  description = "The public subnets for the infra VPC"
  value       = module.infrastructure.infra_public_subnets
}

output "infra_bastion_sg_allow" {
  description = "The security group ID to allow SSH traffic from the bastion to the infra instances"
  value       = module.infrastructure.infra_bastion_sg_allow
}

output "infra_private_zone_id" {
  description = "The Route53 private zone ID for the infra VPC"
  value       = module.infrastructure.infra_private_zone_id
}

output "infra_rds_parameters-mysql57" {
  description = "The RDS parameter group ID for the infra VPC"
  value       = module.infrastructure.infra_rds_parameters-mysql57
}

output "iam_ses_smtp_user_key" {
  description = "The dedicated SES user"
  value       = module.infrastructure.iam_ses_smtp_user_key
}

output "iam_ses_smtp_user_secret" {
  description = "The dedicated SES user secret"
  value       = module.infrastructure.iam_ses_smtp_user_secret
}

output "iam_backup_user_key" {
  description = "The dedicated backup user"
  value       = module.infrastructure.iam_backup_user_key
}

output "iam_backup_user_secret" {
  description = "The dedicated backup user secret"
  value       = module.infrastructure.iam_backup_user_secret
}

