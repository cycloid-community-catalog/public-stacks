#
# Dedicated VPC
#

module "aws-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.70.0"

  name = "${var.project}-eks-${var.env}"
  azs  = local.aws_availability_zones
  cidr = var.vpc_cidr

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = var.private_subnets
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  public_subnets = var.public_subnets
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  enable_dns_hostnames     = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "${var.project}.eks.${var.env}"

  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = merge(local.merged_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}