resource "aws_route53_zone" "vpc_private" {
  name = "${var.project}.eks.${var.env}"

  vpc {
    vpc_id = module.aws-vpc.vpc_id
  }

  tags = merge(local.merged_tags, {
    Name = "${var.project}.eks.${var.env}"
  })

  lifecycle {
    ignore_changes = [vpc]
  }
}