resource "aws_instance" "ec2" {
  ami           = data.aws_ami.debian.id
  instance_type = var.vm_instance_type

  vpc_security_group_ids = [aws_security_group.ec2.id]

  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  disable_api_termination     = false

  root_block_device {
    volume_size           = var.vm_disk_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

# This is a trick to get the updated public IP address even after a change
data "aws_instance" "ec2" {
  instance_id = aws_instance.ec2.id
}

resource "aws_security_group" "ec2" {
  name        = "${var.cyorg}-${var.cypro}-${var.cyenv}-${var.cycom}"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "egress-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ingress-http" {
    type              = "ingress"
    description       = "Allow 80/TCP from internet"
    security_group_id = aws_security_group.ec2.id
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
}

resource "aws_security_group_rule" "ingress-https" {
    type              = "ingress"
    description       = "Allow 80/TCP from internet"
    security_group_id = aws_security_group.ec2.id
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
    from_port         = 443
    to_port           = 443
}