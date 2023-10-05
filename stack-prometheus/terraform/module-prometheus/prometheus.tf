###

# prometheus

###

resource "aws_security_group" "prometheus" {
  name        = "${var.project}-prometheus-${var.env}"
  description = "prometheus ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name         = "${var.project}-prometheus-${var.env}"
    role         = "prometheus"
  })
}

resource "aws_security_group_rule" "any_to_http" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.prometheus.id
}

resource "aws_security_group_rule" "any_to_https" {
  count             = var.enable_https ? 1 : 0
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.prometheus.id
}

resource "aws_security_group_rule" "bastion_to_prometheus_ssh" {
  count                    = var.bastion_sg_allow != "" ? 1 : 0
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_allow
  security_group_id        = aws_security_group.prometheus.id
}

resource "aws_security_group_rule" "prometheus_to_himself_instance_metrics" {
  type              = "ingress"
  from_port         = "9100"
  to_port           = "9100"
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.prometheus.id
}

###

# EC2

###

resource "random_shuffle" "prometheus_subnet_id" {
  input        = var.public_subnets_ids
  result_count = 1
}

resource "aws_instance" "prometheus" {
  ami = data.aws_ami.debian.id

  # associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.prometheus.name
  instance_type        = var.prometheus_type
  key_name             = var.keypair_name
  ebs_optimized        = var.prometheus_ebs_optimized

  vpc_security_group_ids = compact([var.bastion_sg_allow, aws_security_group.prometheus.id])
  subnet_id              = random_shuffle.prometheus_subnet_id.result[0]

  root_block_device {
    volume_size           = var.prometheus_disk_size
    volume_type           = var.prometheus_disk_type
    delete_on_termination = true
  }

  volume_tags = merge(local.merged_tags, {
    Name         = "${var.project}-prometheus-${var.short_region[var.aws_region]}-${var.env}"
    role         = "prometheus"
  })

  tags = merge(local.merged_tags, {
    Name         = "${var.project}-prometheus-${var.short_region[var.aws_region]}-${var.env}"
    role         = "prometheus"
  })
}

###

# EIP

###

resource "aws_eip" "prometheus" {
  instance = aws_instance.prometheus.id
  vpc      = true
  count    = var.prometheus_enable_eip ? 1 : 0
}

###

# Cloudwatch Alarms

###

resource "aws_cloudwatch_metric_alarm" "recover-prometheus" {
  alarm_actions       = ["arn:aws:automate:${var.aws_region}:ec2:recover"]
  alarm_description   = "Recover the instance"
  alarm_name          = "cycloid-engine_recover-${var.project}-prometheus-${var.env}"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = aws_instance.prometheus.id
  }

  evaluation_periods        = "2"
  insufficient_data_actions = []
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "0"
}

