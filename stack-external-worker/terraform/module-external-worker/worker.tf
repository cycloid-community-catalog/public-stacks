###

# worker

###

resource "aws_security_group" "worker" {
  name        = "${var.project}-worker-${var.env}"
  description = "Front ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  #  ingress {
  #    from_port       = 80
  #    to_port         = 80
  #    protocol        = "tcp"
  #    security_groups = ["${aws_security_group.alb-worker.id}"]
  #  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name       = "${var.project}-worker-${var.env}"
    role       = "worker"
  })
}

###

# ASG

###

locals {
  default_worker_launch_template_id = {
    "spot"     = aws_launch_template.worker.id
    "ondemand" = aws_launch_template.worker_ondemand.id
  }

  default_worker_launch_template_latest_version = {
    "spot"     = aws_launch_template.worker.latest_version
    "ondemand" = aws_launch_template.worker_ondemand.latest_version
  }
}

locals {
  worker_launch_template_id             = var.worker_launch_template_id != "" ? var.worker_launch_template_id : local.default_worker_launch_template_id[var.worker_launch_template_profile]
  worker_launch_template_latest_version = var.worker_launch_template_latest_version != "" ? var.worker_launch_template_latest_version : local.default_worker_launch_template_latest_version[var.worker_launch_template_profile]

  front_tags =  concat([
            for tag in keys(local.merged_tags):
               { "Key" = tag, "Value" = local.merged_tags[tag], "PropagateAtLaunch" = "true" }
          ],
          [
               { "Key" = "Name", "Value" = "${var.project}-worker-${var.short_region[data.aws_region.current.name]}-${var.env}", "PropagateAtLaunch" = "true" },
               { "Key" = "role", "Value" = "worker", "PropagateAtLaunch" = "true" }
          ])
}

resource "aws_cloudformation_stack" "worker" {
  name = "${var.project}-worker-${var.env}"

  template_body = <<EOF
{
  "Resources": {
    "externalWorkers${var.env}": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": ${jsonencode(var.zones)},
        "VPCZoneIdentifier": ${jsonencode(var.public_subnets_ids)},
        "LaunchTemplate": {
            "LaunchTemplateId": "${local.worker_launch_template_id}",
            "Version" : "${local.worker_launch_template_latest_version}"
        },
        "MaxSize": "${var.worker_asg_max_size}",
        "DesiredCapacity" : "${var.worker_count}",
        "MinSize": "${var.worker_asg_min_size}",
        "TerminationPolicies": ["OldestLaunchConfiguration", "NewestInstance"],
        "HealthCheckType": "EC2",
        "HealthCheckGracePeriod": 600,
        "Tags" : ${jsonencode(local.front_tags)}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.worker_launch_template_profile == "spot" ? 0 : 1}",
          "MinSuccessfulInstancesPercent": "${var.worker_launch_template_profile == "spot" ? 50 : 100}",
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
       "Value": {"Ref": "externalWorkers${var.env}"}
    }
  }
}
EOF

}

# Cloudwatch autoscaling
# Disable for now as concourse don't really like scale down
#resource "aws_autoscaling_policy" "worker-scale-up" {
#  name                   = "${var.project}-worker-scale-up-${var.env}"
#  scaling_adjustment     = "${var.worker_asg_scale_up_scaling_adjustment}"
#  adjustment_type        = "ChangeInCapacity"
#  cooldown               = "${var.worker_asg_scale_up_cooldown}"
#  autoscaling_group_name = "${aws_cloudformation_stack.worker.outputs["AsgName"]}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "worker-scale-up" {
#  alarm_name          = "${var.project}-worker-scale-up-${var.env}"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "${var.worker_asg_scale_up_threshold}"
#
#  dimensions {
#    AutoScalingGroupName = "${aws_cloudformation_stack.worker.outputs["AsgName"]}"
#  }
#
#  alarm_description = "This metric monitor ec2 cpu utilization on ${var.project} ${var.env}"
#  alarm_actions     = ["${aws_autoscaling_policy.worker-scale-up.arn}"]
#}
#
#resource "aws_autoscaling_policy" "worker-scale-down" {
#  name                   = "${var.project}-worker-scale-down-${var.env}"
#  scaling_adjustment     = "${var.worker_asg_scale_down_scaling_adjustment}"
#  adjustment_type        = "ChangeInCapacity"
#  cooldown               = "${var.worker_asg_scale_down_cooldown}"
#  autoscaling_group_name = "${aws_cloudformation_stack.worker.outputs["AsgName"]}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "worker-scale-down" {
#  alarm_name          = "${var.project}-worker-scale-down-${var.env}"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "${var.worker_asg_scale_down_threshold}"
#
#  dimensions {
#    AutoScalingGroupName = "${aws_cloudformation_stack.worker.outputs["AsgName"]}"
#  }
#
#  alarm_description = "This metric monitor ec2 cpu utilization on ${var.project} ${var.env}"
#  alarm_actions     = ["${aws_autoscaling_policy.worker-scale-down.arn}"]
#}
