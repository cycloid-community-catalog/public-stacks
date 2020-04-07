resource "aws_security_group" "es" {
  name        = "${var.project}-es-${var.env}"
  description = "Es ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    role = "es"
    Name = "${var.project}-es-${var.env}"
  })
}

resource "aws_security_group_rule" "allowed_secgroup" {
  count                    = var.allowed_secgroup != "" ? 1 : 0
  type                     = "ingress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "TCP"
  source_security_group_id = var.allowed_secgroup
  security_group_id        = aws_security_group.es.id
}
