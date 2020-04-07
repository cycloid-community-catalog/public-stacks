resource "aws_security_group" "allow_bastion" {
  count = length(var.bastion_sg_id) > 0 ? 1 : 0

  name        = "${var.project}-${var.env}-allow-bastion-eks"
  description = "Allow SSH traffic from the bastion to the EKS env"
  vpc_id      = module.aws-vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name = "${var.project}-${var.env}-allow-bastion-eks"
  })
}
