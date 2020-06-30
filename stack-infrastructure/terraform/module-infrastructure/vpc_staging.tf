#
# Variables
#
variable "staging_cidr" {
  description = "The CIDR of the staging VPC"
  default     = "10.1.0.0/16"
}

variable "staging_private_subnets" {
  description = "The private subnets for the staging VPC"
  default     = ["10.1.0.0/24", "10.1.2.0/24", "10.1.4.0/24"]
}

variable "staging_public_subnets" {
  description = "The public subnets for the staging VPC"
  default     = ["10.1.1.0/24", "10.1.3.0/24", "10.1.5.0/24"]
}

variable "staging_elasticache_subnets" {
  description = "The Elasticache subnets for the staging VPC"
  default     = []
}

variable "staging_rds_subnets" {
  description = "The RDS subnets for the staging VPC"
  default     = ["10.1.2.0/24", "10.1.6.0/24", "10.1.10.0/24"]
}

variable "staging_redshift_subnets" {
  description = "The Redshift subnets for the staging VPC"
  default     = []
}

# Fix for value of count cannot be computed, generating the count as the same way as amazon vpc module do : https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L5
locals {
  staging_max_subnet_length = max(
    length(var.staging_private_subnets),
    length(var.staging_elasticache_subnets),
    length(var.staging_rds_subnets),
    length(var.staging_redshift_subnets),
  )
  staging_nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(local.aws_availability_zones) : local.staging_max_subnet_length
}

#
# Create VPC
#
module "staging_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.17"

  name = "${var.customer}-staging${var.suffix}"
  azs  = local.aws_availability_zones
  cidr = var.staging_cidr

  private_subnets     = var.staging_private_subnets
  enable_nat_gateway  = true
  single_nat_gateway  = true
  public_subnets      = var.staging_public_subnets
  elasticache_subnets = var.staging_elasticache_subnets
  database_subnets    = var.staging_rds_subnets
  redshift_subnets    = var.staging_redshift_subnets

  enable_dns_hostnames     = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "${var.customer}.staging"

  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = local.merged_tags
}

resource "aws_vpc_peering_connection" "infra_staging" {
  peer_vpc_id = module.infra_vpc.vpc_id
  vpc_id      = module.staging_vpc.vpc_id
  auto_accept = true

  tags = merge(local.merged_tags, {
    Name       = "VPC Peering between infra and staging"
  })
}

resource "aws_route" "infra_staging_public" {
  #count = "${length(module.infra_vpc.public_route_table_ids)}"
  count = var.create_vpc && length(var.infra_public_subnets) > 0 ? 1 : 0

  route_table_id            = element(module.infra_vpc.public_route_table_ids, count.index)
  destination_cidr_block    = var.staging_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_staging.id
}

resource "aws_route" "infra_staging_private" {
  #count = "${length(module.infra_vpc.private_route_table_ids)}"
  count = var.create_vpc && local.infra_max_subnet_length > 0 ? local.infra_nat_gateway_count : 0

  route_table_id            = element(module.infra_vpc.private_route_table_ids, count.index)
  destination_cidr_block    = var.staging_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_staging.id
}

resource "aws_route" "staging_infra_public" {
  #count = "${length(module.infra_vpc.public_route_table_ids)}"
  count = var.create_vpc && length(var.staging_public_subnets) > 0 ? 1 : 0

  route_table_id            = element(module.staging_vpc.public_route_table_ids, count.index)
  destination_cidr_block    = var.infra_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_staging.id
}

resource "aws_route" "staging_infra_private" {
  #count = "${length(module.infra_vpc.private_route_table_ids)}"
  count = var.create_vpc && local.staging_max_subnet_length > 0 ? local.staging_nat_gateway_count : 0

  route_table_id            = element(module.staging_vpc.private_route_table_ids, count.index)
  destination_cidr_block    = var.infra_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_staging.id
}

resource "aws_security_group" "allow_bastion_staging" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "allow-bastion-staging${var.suffix}"
  description = "Allow SSH traffic from the bastion to the staging env"
  vpc_id      = module.staging_vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion[0].id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name       = "allow-bastion-staging${var.suffix}"
  })
}

# Create route53 zones
## Private zone
resource "aws_route53_zone" "staging_private" {
  name = "${var.customer}.staging"

  vpc {
    vpc_id = module.staging_vpc.vpc_id
  }

  tags = local.merged_tags

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "staging_private_infra" {
  zone_id = aws_route53_zone.staging_private.zone_id
  vpc_id  = module.infra_vpc.vpc_id
  count   = var.infra_associate_vpc_to_all_private_zones ? 1 : 0
}

#
# mysql
#

resource "aws_db_parameter_group" "staging_rds-optimized-mysql57" {
  name        = "rds-optimized-mysql-${var.customer}-staging"
  family      = "mysql5.7"
  description = "Cycloid optimizations for ${var.customer}-staging"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  parameter {
    name         = "query_cache_type"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_buffer_pool_size"
    value        = "{DBInstanceClassMemory*2/3}"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = "67108864"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_size"
    value        = "67108864"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tmp_table_size"
    value        = "134217728"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_heap_table_size"
    value        = "134217728"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "file"
  }
}

#
# output
#

// Expose the mysql rds parameters
output "staging_rds_parameters-mysql57" {
  value = aws_db_parameter_group.staging_rds-optimized-mysql57.id
}

// Expose the private zone id
output "staging_private_zone_id" {
  value = aws_route53_zone.staging_private.zone_id
}

output "staging_bastion_sg_allow" {
  value = element(aws_security_group.allow_bastion_staging.*.id, 0)
}

output "staging_vpc_id" {
  value = module.staging_vpc.vpc_id
}

output "staging_vpc_cidr" {
  value = var.staging_cidr
}

output "staging_public_route_table_ids" {
  value = module.staging_vpc.public_route_table_ids
}

output "staging_private_route_table_ids" {
  value = module.staging_vpc.private_route_table_ids
}

output "staging_private_subnets" {
  value = module.staging_vpc.private_subnets
}

output "staging_public_subnets" {
  value = module.staging_vpc.public_subnets
}

output "staging_elasticache_subnets" {
  value = module.staging_vpc.elasticache_subnets
}

output "staging_elasticache_subnet_group" {
  value = module.staging_vpc.elasticache_subnet_group
}

output "staging_rds_subnets" {
  value = module.staging_vpc.database_subnets
}

output "staging_rds_subnet_group" {
  value = module.staging_vpc.database_subnet_group
}

output "staging_redshift_subnets" {
  value = module.staging_vpc.redshift_subnets
}

output "staging_redshift_subnet_group" {
  value = module.staging_vpc.redshift_subnet_group
}

