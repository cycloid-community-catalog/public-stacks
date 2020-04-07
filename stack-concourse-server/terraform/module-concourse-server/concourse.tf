###

# Concourse server

###

resource "aws_security_group" "alb-concourse" {
  name        = "${var.project}-alb-concourse-${var.env}"
  description = "${var.env} concourse ALB for ${var.project}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    cycloid.io = "true"
    Name       = "${var.project}-alb-concourse-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    role       = "concourse-server"
  }

  count = "${var.concourse_create_alb ? 1 : 0}"
}

resource "aws_security_group" "concourse" {
  name        = "${var.project}-concourse-${var.env}"
  description = "${var.env} Concourse server for ${var.project}"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    cycloid.io = "true"
    Name       = "${var.project}-concourse-${var.env}"
    env        = "${var.env}"
    project    = "${var.project}"
    role       = "concourse-server"
  }
}

resource "aws_security_group_rule" "http-sg" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${element(aws_security_group.alb-concourse.*.id, count.index)}"
  count                    = "${var.concourse_create_alb ? 1 : 0}"

  security_group_id = "${aws_security_group.concourse.id}"
}

resource "aws_security_group_rule" "http-sg-var" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${var.concourse_alb_security_group_id}"
  count                    = "${var.concourse_create_alb ? 0 : 1}"

  security_group_id = "${aws_security_group.concourse.id}"
}

resource "aws_security_group_rule" "ssh-sg" {
  type                     = "ingress"
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
  source_security_group_id = "${element(var.workers_sg_allow, count.index)}"
  count                    = "${length(var.workers_sg_allow)}"

  security_group_id = "${aws_security_group.concourse.id}"
}

resource "aws_security_group_rule" "ssh-cidr" {
  type        = "ingress"
  from_port   = 2222
  to_port     = 2222
  protocol    = "tcp"
  cidr_blocks = ["${var.workers_cidr_allow}"]
  count       = "${length(var.workers_cidr_allow) > 0 ? 1 : 0}"

  security_group_id = "${aws_security_group.concourse.id}"
}

resource "aws_launch_template" "concourse" {
  name_prefix = "concourse_${var.env}_version_"

  image_id      = "${data.aws_ami.concourse.id}"
  instance_type = "${var.concourse_type}"
  user_data     = "${base64encode(data.template_file.user_data_concourse.rendered)}"
  key_name      = "${var.keypair_name}"

  network_interfaces {
    associate_public_ip_address = "${var.concourse_associate_public_ip_address}"
    delete_on_termination       = true

    security_groups = ["${compact(list(
        "${var.bastion_sg_allow}",
        "${aws_security_group.concourse.id}",
        "${var.metrics_sg_allow}",
      ))}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  ebs_optimized = "${var.concourse_ebs_optimized}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.concourse_profile.name}"
  }

  tags {
    cycloid.io = "true"
    Name       = "${var.project}-concourse-template-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    role       = "concourse-server-template"
  }

  tag_specifications {
    resource_type = "instance"

    tags {
      cycloid.io = "true"
      Name       = "${var.project}-concourse-${var.env}"
      client     = "${var.customer}"
      env        = "${var.env}"
      project    = "${var.project}"
      role       = "concourse-server"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags {
      cycloid.io = "true"
      Name       = "${var.project}-concourse-${var.env}"
      client     = "${var.customer}"
      env        = "${var.env}"
      project    = "${var.project}"
      role       = "concourse-server"
    }
  }

  block_device_mappings {
    device_name = "xvda"

    ebs {
      volume_size           = "${var.concourse_disk_size}"
      volume_type           = "${var.concourse_disk_type}"
      delete_on_termination = true
    }
  }

  block_device_mappings {
    device_name  = "/dev/xvdf"
    virtual_name = "container_datas"

    ebs {
      volume_size           = "${var.concourse_volume_disk_size}"
      volume_type           = "${var.concourse_volume_disk_type}"
      delete_on_termination = true
    }
  }
}

###

# ASG

###

resource "aws_cloudformation_stack" "concourse" {
  name = "${var.project}-concourse-${var.env}"

  template_body = <<EOF
{
  "Resources": {
    "concourseServer${var.env}": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": ${jsonencode(var.zones)},
        "VPCZoneIdentifier": ${jsonencode(var.private_subnets_ids)},
        "LaunchTemplate": {
            "LaunchTemplateId": "${aws_launch_template.concourse.id}",
            "Version" : "${aws_launch_template.concourse.latest_version}"
        },
        "MaxSize": "${var.concourse_asg_max_size}",
        "DesiredCapacity" : "${var.concourse_count}",
        "MinSize": "${var.concourse_asg_min_size}",
        "TerminationPolicies": ["OldestLaunchConfiguration", "NewestInstance"],
        "HealthCheckType": "EC2",
        "HealthCheckGracePeriod": 600,
        "Tags" : [
          { "Key" : "Name", "Value" : "${var.project}-concourse-${lookup(var.short_region, var.aws_region)}-${var.env}", "PropagateAtLaunch" : "true" },
          { "Key" : "client", "Value" : "${var.customer}", "PropagateAtLaunch" : "true" },
          { "Key" : "env", "Value" : "${var.env}", "PropagateAtLaunch" : "true" },
          { "Key" : "project", "Value" : "${var.project}", "PropagateAtLaunch" : "true" },
          { "Key" : "role", "Value" : "concourse-server", "PropagateAtLaunch" : "true" },
          { "Key" : "cycloid.io", "Value" : "true", "PropagateAtLaunch" : "true" }
        ]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "0",
          "MinSuccessfulInstancesPercent": "50",
          "SuspendProcesses": ["ScheduledActions"],
          "MaxBatchSize": "2",
          "PauseTime": "PT8M",
          "WaitOnResourceSignals": "true"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
       "Value": {"Ref": "concourseServer${var.env}"}
    }
  }
}
EOF
}

###

# ALB loadbalancer

###

resource "aws_alb" "concourse" {
  name            = "${var.project}-alb-${var.env}"
  security_groups = ["${aws_security_group.alb-concourse.id}"]
  subnets         = ["${var.public_subnets_ids}"]

  enable_cross_zone_load_balancing = true
  idle_timeout                     = 600

  tags {
    Name       = "${var.project}-alb-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    cycloid.io = "true"
    role       = "concourse-server"
  }

  count = "${var.concourse_create_alb ? 1 : 0}"
}

# 80 default redirect to 443
resource "aws_alb_listener" "concourse-80" {
  load_balancer_arn = "${aws_alb.concourse.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  count = "${var.concourse_create_alb ? 1 : 0}"
}

# 443 default to fixed response
resource "aws_alb_listener" "concourse-443" {
  load_balancer_arn = "${aws_alb.concourse.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${var.concourse_acm_certificate_arn}"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }

  count = "${var.concourse_create_alb ? 1 : 0}"
}

resource "aws_alb_target_group" "concourse-8080" {
  name     = "${var.project}-http-${var.env}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path     = "/api/v1/info"
    matcher  = "200"
    timeout  = 15
    interval = 45
  }

  tags {
    cycloid.io = "true"
    Name       = "${var.project}-http-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    role       = "concourse-server"
  }
}

// resource "aws_alb_target_group_attachment" "concourse" {
//   target_group_arn = "${aws_alb_target_group.concourse-8080.arn}"
//   target_id        = "${module.prometheus.prometheus_instance_id}" // ?
//   port             = 80
// }

resource "aws_autoscaling_attachment" "concourse-8080" {
  autoscaling_group_name = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
  alb_target_group_arn   = "${aws_alb_target_group.concourse-8080.arn}"
}

resource "aws_alb_listener_rule" "concourse" {
  count        = "${var.concourse_create_alb ? 1 : 0}"
  listener_arn = "${element(aws_alb_listener.concourse-443.*.arn, count.index)}"
  priority     = 80

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.concourse-8080.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.concourse_domain}"]
  }
}

resource "aws_alb_listener_rule" "concourse-var" {
  count        = "${var.concourse_create_alb ? 0 : 1}"
  listener_arn = "${var.concourse_alb_listener_arn}"
  priority     = 80

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.concourse-8080.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.concourse_domain}"]
  }
}

###

# NLB

###

resource "aws_lb" "concourse" {
  name                             = "${var.project}-nlb-${var.env}"
  load_balancer_type               = "network"
  internal                         = false
  subnets                          = ["${var.public_subnets_ids}"]
  enable_cross_zone_load_balancing = true

  tags {
    Name       = "${var.project}-nlb-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    cycloid.io = "true"
    role       = "concourse-server"
  }
}

resource "aws_lb_listener" "concourse-2222" {
  load_balancer_arn = "${aws_lb.concourse.arn}"
  protocol          = "TCP"
  port              = "2222"

  default_action {
    target_group_arn = "${aws_lb_target_group.concourse-2222.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "concourse-2222" {
  name     = "${var.project}-ssh-${var.env}"
  protocol = "TCP"
  port     = 2222
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    port                = 2222
    protocol            = "TCP"
  }

  tags {
    cycloid.io = "true"
    Name       = "${var.project}-ssh-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    role       = "concourse-server"
  }
}

resource "aws_autoscaling_attachment" "concourse-2222" {
  autoscaling_group_name = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
  alb_target_group_arn   = "${aws_lb_target_group.concourse-2222.arn}"
}

###


# Cloudwatch autoscaling


###


# Disable for now as concourse don't really like scale down
#resource "aws_autoscaling_policy" "concourse-scale-up" {
#  name                   = "${var.project}-concourse-scale-up-${var.env}"
#  scaling_adjustment     = "${var.concourse_asg_scale_up_scaling_adjustment}"
#  adjustment_type        = "ChangeInCapacity"
#  cooldown               = "${var.concourse_asg_scale_up_cooldown}"
#  autoscaling_group_name = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "concourse-scale-up" {
#  alarm_name          = "${var.project}-concourse-scale-up-${var.env}"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "${var.concourse_asg_scale_up_threshold}"
#
#  dimensions {
#    AutoScalingGroupName = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
#  }
#
#  alarm_description = "This metric monitor ec2 cpu utilization on ${var.project} ${var.env}"
#  alarm_actions     = ["${aws_autoscaling_policy.concourse-scale-up.arn}"]
#}
#
#resource "aws_autoscaling_policy" "concourse-scale-down" {
#  name                   = "${var.project}-concourse-scale-down-${var.env}"
#  scaling_adjustment     = "${var.concourse_asg_scale_down_scaling_adjustment}"
#  adjustment_type        = "ChangeInCapacity"
#  cooldown               = "${var.concourse_asg_scale_down_cooldown}"
#  autoscaling_group_name = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "concourse-scale-down" {
#  alarm_name          = "${var.project}-concourse-scale-down-${var.env}"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "${var.concourse_asg_scale_down_threshold}"
#
#  dimensions {
#    AutoScalingGroupName = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
#  }
#
#  alarm_description = "This metric monitor ec2 cpu utilization on ${var.project} ${var.env}"
#  alarm_actions     = ["${aws_autoscaling_policy.concourse-scale-down.arn}"]
#}

