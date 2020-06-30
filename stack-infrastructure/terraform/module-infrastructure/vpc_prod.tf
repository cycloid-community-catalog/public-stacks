#
# Variables
#

variable "prod_cidr" {
  description = "The CIDR of the prod VPC"
  default     = "10.2.0.0/16"
}

variable "prod_private_subnets" {
  description = "The private subnets for the prod VPC"
  default     = ["10.2.0.0/24", "10.2.2.0/24", "10.2.4.0/24"]
}

variable "prod_public_subnets" {
  description = "The public subnets for the prod VPC"
  default     = ["10.2.1.0/24", "10.2.3.0/24", "10.2.5.0/24"]
}

variable "prod_elasticache_subnets" {
  description = "The Elasticache subnets for the prod VPC"
  default     = []
}

variable "prod_rds_subnets" {
  description = "The RDS subnets for the prod VPC"
  default     = ["10.2.2.0/24", "10.2.6.0/24", "10.2.10.0/24"]
}

variable "prod_redshift_subnets" {
  description = "The Redshift subnets for the prod VPC"
  default     = []
}

#
# Create VPC
#

module "prod_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.17"

  name = "${var.customer}-prod${var.suffix}"
  azs  = local.aws_availability_zones
  cidr = var.prod_cidr

  private_subnets     = var.prod_private_subnets
  enable_nat_gateway  = true
  single_nat_gateway  = true
  public_subnets      = var.prod_public_subnets
  elasticache_subnets = var.prod_elasticache_subnets
  database_subnets    = var.prod_rds_subnets
  redshift_subnets    = var.prod_redshift_subnets

  enable_dns_hostnames     = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "${var.customer}.prod"

  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = local.merged_tags
}

resource "aws_vpc_peering_connection" "infra_prod" {
  peer_vpc_id = module.infra_vpc.vpc_id
  vpc_id      = module.prod_vpc.vpc_id
  auto_accept = true

  tags = merge(local.merged_tags, {
    Name       = "VPC Peering between infra and prod"
  })
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  default     = false
}

# Fix for value of count cannot be computed, generating the count as the same way as amazon vpc module do : https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L5
locals {
  prod_max_subnet_length = max(
    length(var.prod_private_subnets),
    length(var.prod_elasticache_subnets),
    length(var.prod_rds_subnets),
    length(var.prod_redshift_subnets),
  )
  prod_nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(local.aws_availability_zones) : local.prod_max_subnet_length
}

resource "aws_route" "infra_prod_public" {
  count = var.create_vpc && length(var.infra_public_subnets) > 0 ? 1 : 0

  #  count = "${length(module.infra_vpc.public_route_table_ids)}"

  route_table_id            = element(module.infra_vpc.public_route_table_ids, count.index)
  destination_cidr_block    = var.prod_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_prod.id
}

resource "aws_route" "infra_prod_private" {
  #count = "${length(module.infra_vpc.private_route_table_ids)}"
  count = var.create_vpc && local.infra_max_subnet_length > 0 ? local.infra_nat_gateway_count : 0

  route_table_id            = element(module.infra_vpc.private_route_table_ids, count.index)
  destination_cidr_block    = var.prod_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_prod.id
}

resource "aws_route" "prod_infra_public" {
  #count = "${length(module.infra_vpc.public_route_table_ids)}"
  count = var.create_vpc && length(var.prod_public_subnets) > 0 ? 1 : 0

  route_table_id            = element(module.prod_vpc.public_route_table_ids, count.index)
  destination_cidr_block    = var.infra_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_prod.id
}

resource "aws_route" "prod_infra_private" {
  #count = "${length(module.infra_vpc.private_route_table_ids)}"
  count = var.create_vpc && local.prod_max_subnet_length > 0 ? local.prod_nat_gateway_count : 0

  route_table_id            = element(module.prod_vpc.private_route_table_ids, count.index)
  destination_cidr_block    = var.infra_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.infra_prod.id
}

resource "aws_security_group" "allow_bastion_prod" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "allow-bastion-prod${var.suffix}"
  description = "Allow SSH traffic from the bastion to the prod env"
  vpc_id      = module.prod_vpc.vpc_id

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
    Name       = "allow-bastion-prod${var.suffix}"
  })
}

# Create route53 zones
## Private zone
resource "aws_route53_zone" "prod_private" {
  name = "${var.customer}.prod"

  vpc {
    vpc_id = module.prod_vpc.vpc_id
  }

  tags = local.merged_tags

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "prod_private_infra" {
  zone_id = aws_route53_zone.prod_private.zone_id
  vpc_id  = module.infra_vpc.vpc_id
  count   = var.infra_associate_vpc_to_all_private_zones ? 1 : 0
}

#
# mysql
#

resource "aws_db_parameter_group" "prod_rds-optimized-mysql57" {
  name        = "rds-optimized-mysql-${var.customer}-prod"
  family      = "mysql5.7"
  description = "Cycloid optimizations for ${var.customer}-prod"

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
output "prod_rds_parameters-mysql57" {
  value = aws_db_parameter_group.prod_rds-optimized-mysql57.id
}

// Expose the private zone id
output "prod_private_zone_id" {
  value = aws_route53_zone.prod_private.zone_id
}

output "prod_bastion_sg_allow" {
  value = element(aws_security_group.allow_bastion_prod.*.id, 0)
}

output "prod_vpc_id" {
  value = module.prod_vpc.vpc_id
}

output "prod_vpc_cidr" {
  value = var.prod_cidr
}

output "prod_public_route_table_ids" {
  value = module.prod_vpc.public_route_table_ids
}

output "prod_private_route_table_ids" {
  value = module.prod_vpc.private_route_table_ids
}

output "prod_private_subnets" {
  value = module.prod_vpc.private_subnets
}

output "prod_public_subnets" {
  value = module.prod_vpc.public_subnets
}

output "prod_elasticache_subnets" {
  value = module.prod_vpc.elasticache_subnets
}

output "prod_elasticache_subnet_group" {
  value = module.prod_vpc.elasticache_subnet_group
}

output "prod_rds_subnets" {
  value = module.prod_vpc.database_subnets
}

output "prod_rds_subnet_group" {
  value = module.prod_vpc.database_subnet_group
}

output "prod_redshift_subnets" {
  value = module.prod_vpc.redshift_subnets
}

output "prod_redshift_subnet_group" {
  value = module.prod_vpc.redshift_subnet_group
}

