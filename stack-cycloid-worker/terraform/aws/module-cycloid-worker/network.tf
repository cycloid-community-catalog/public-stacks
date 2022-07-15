data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.merged_tags, {
    Name       = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
    role       = "cycloid-worker"
  })
}