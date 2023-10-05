#
# Variables
#
variable "infra_cidr" {
  description = "The CIDR of the infra VPC"
  default     = "10.0.0.0/16"
}

variable "infra_private_subnets" {
  description = "The private subnets for the infra VPC"
  default     = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}

variable "infra_public_subnets" {
  description = "The public subnets for the infra VPC"
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

# Allow the infra VPC to access prod and staging privates zones.
variable "infra_associate_vpc_to_all_private_zones" {
  description = "Should be true if you want to associate the infra VPC to staging and prod privates zones."
  default     = false
}

variable "bastion_count" {
  description = "Number of bastions to create (use 0 if you want no bastion)"
  default     = 1
}

variable "bastion_allowed_networks" {
  description = "Networks allowed to connect to the bastion using SSH"
  default     = "0.0.0.0/0"
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  default     = "t3.micro"
}

# Fix for value of count cannot be computed, generating the count as the same way as amazon vpc module do : https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L5
locals {
  infra_max_subnet_length = max(length(var.infra_private_subnets))

  #infra_max_subnet_length = "${max(length(var.infra_private_subnets), length(var.infra_elasticache_subnets), length(var.infra_rds_subnets), length(var.infra_redshift_subnets))}"
  infra_nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(local.aws_availability_zones) : local.infra_max_subnet_length
}

#
# Create VPC
#

module "infra_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.17"

  name = "${var.customer}-infra${var.suffix}"
  azs  = local.aws_availability_zones
  cidr = var.infra_cidr

  private_subnets    = var.infra_private_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnets     = var.infra_public_subnets

  enable_dns_hostnames     = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "${var.customer}.infra"

  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = local.merged_tags
}

resource "aws_security_group" "allow_bastion_infra" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "allow-bastion-infra${var.suffix}"
  description = "Allow SSH traffic from the bastion to the infra"
  vpc_id      = module.infra_vpc.vpc_id

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
    Name       = "allow-bastion-infra${var.suffix}"
  })
}

# Create route53 zones
## Private zone
resource "aws_route53_zone" "infra_private" {
  name = "${var.customer}.infra"

  vpc {
    vpc_id = module.infra_vpc.vpc_id
  }

  tags = local.merged_tags
}

// Expose the private zone id
output "infra_private_zone_id" {
  value = aws_route53_zone.infra_private.zone_id
}

output "infra_bastion_sg_allow" {
  value = element(aws_security_group.allow_bastion_infra.*.id, 0)
}

#
# mysql
#

resource "aws_db_parameter_group" "infra_rds-optimized-mysql57" {
  name        = "rds-optimized-mysql-${var.customer}-infra"
  family      = "mysql5.7"
  description = "Cycloid optimizations for ${var.customer}-infra"

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

// Expose the mysql rds parameters
output "infra_rds_parameters-mysql57" {
  value = aws_db_parameter_group.infra_rds-optimized-mysql57.id
}

output "infra_vpc_id" {
  value = module.infra_vpc.vpc_id
}

output "infra_vpc_cidr" {
  value = var.infra_cidr
}

output "infra_public_route_table_ids" {
  value = module.infra_vpc.public_route_table_ids
}

output "infra_private_route_table_ids" {
  value = module.infra_vpc.private_route_table_ids
}

output "infra_private_subnets" {
  value = module.infra_vpc.private_subnets
}

output "infra_public_subnets" {
  value = module.infra_vpc.public_subnets
}

