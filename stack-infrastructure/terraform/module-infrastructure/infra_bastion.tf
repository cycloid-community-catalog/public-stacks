resource "aws_security_group" "bastion" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "bastion${var.suffix}"
  description = "Allow SSH traffic from the internet"
  vpc_id      = module.infra_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_allowed_networks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name       = "bastion${var.suffix}"
  })
}

resource "aws_eip" "bastion" {
  count = var.bastion_count

  instance = aws_instance.bastion[0].id
  vpc      = true

  tags = merge(local.merged_tags, {
    Name       = "${var.customer}-bastion${count.index}${var.suffix}"
  })
}

resource "aws_instance" "bastion" {
  count = var.bastion_count

  ami           = data.aws_ami.debian_stretch.id
  instance_type = var.bastion_instance_type
  key_name      = var.keypair_name != "" ? var.keypair_name : "${var.customer}-${var.project}${var.suffix}"

  vpc_security_group_ids = compact([var.metrics_allowed_sg, aws_security_group.bastion[0].id])

  iam_instance_profile    = aws_iam_instance_profile.infra.name
  subnet_id               = element(module.infra_vpc.public_subnets, count.index)
  disable_api_termination = false

  tags = merge(local.merged_tags, {
    Name       = "${var.customer}-bastion${count.index}${var.suffix}"
    role       = "bastion"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_cloudwatch_metric_alarm" "recover-bastion" {
  count = var.bastion_count

  alarm_actions     = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  alarm_description = "Recover the instance"

  alarm_name          = "recover-bastion${var.suffix}"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = element(aws_instance.bastion.*.id, count.index)
  }

  evaluation_periods        = "2"
  insufficient_data_actions = []
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "0"
}

