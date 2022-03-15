#
# Security Groups
#

resource "aws_security_group" "eks-node" {
  name        = "${var.project}-${var.env}-eks-node-${var.node_group_name}"
  description = "Security group for node group ${var.node_group_name} in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name                           = "${var.project}-${var.env}-eks-node-${var.node_group_name}"
    role                           = "eks-node"
    "kubernetes.io/nodegroup/name" = var.node_group_name
    "eks:cluster-name"             = var.cluster_name
    "eks:nodegroup-name"           = var.node_group_name
  })
}

#
# Auto Scaling Group
#

locals {
  default_node_launch_template_id = {
    "spot"     = aws_launch_template.eks-node-spot.id
    "ondemand" = aws_launch_template.eks-node-ondemand.id
  }

  default_node_launch_template_latest_version = {
    "spot"     = aws_launch_template.eks-node-spot.latest_version
    "ondemand" = aws_launch_template.eks-node-ondemand.latest_version
  }

  node_launch_template_id             = var.node_launch_template_id != "" ? var.node_launch_template_id : local.default_node_launch_template_id[var.node_launch_template_profile]
  node_launch_template_latest_version = var.node_launch_template_latest_version != "" ? var.node_launch_template_latest_version : local.default_node_launch_template_latest_version[var.node_launch_template_profile]

  node_tags = concat(
    [
      for tag in keys(local.merged_tags) :
      { "Key" = tag, "Value" = local.merged_tags[tag], "PropagateAtLaunch" = "true" }
    ],
    [
      { "Key" = "Name", "Value" = "${var.project}-${var.env}-eks-node-${var.node_group_name}", "PropagateAtLaunch" = "true" },
      { "Key" = "role", "Value" = "eks-node", "PropagateAtLaunch" = "true" },
      { "Key" = "Spot", "Value" = "%{if var.node_launch_template_profile == "spot"}true%{else}false%{endif}", "PropagateAtLaunch" = "true" },
      { "Key" = "kubernetes.io/cluster/${var.cluster_name}", "Value" = "owned", "PropagateAtLaunch" = "true" },
      { "Key" = "kubernetes.io/nodegroup/name", "Value" = var.node_group_name, "PropagateAtLaunch" = "true" },
      { "Key" = "eks:cluster-name", "Value" = var.cluster_name, "PropagateAtLaunch" = "true" },
      { "Key" = "eks:nodegroup-name", "Value" = var.node_group_name, "PropagateAtLaunch" = "true" }
    ],
    [
      for tag in keys(local.cluster_autoscaler_tags) :
      { "Key" = tag, "Value" = local.cluster_autoscaler_tags[tag], "PropagateAtLaunch" = "false" }
      if var.node_enable_cluster_autoscaler_tags
    ]
  )
}

data "aws_subnet_ids" "selected" {
  vpc_id = var.vpc_id

  filter {
    name   = "subnet-id"
    values = var.private_subnets_ids
  }
  filter {
    name   = "availability-zone"
    values = local.aws_availability_zones
  }
}

# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
data "template_file" "user-data-eks-node" {
  template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    signal_stack_name  = "${var.project}-${var.env}-eks-node-${var.node_group_name}"
    signal_resource_id = "EKSNodes${var.env}"

    apiserver_endpoint = var.control_plane_endpoint
    b64_cluster_ca     = var.control_plane_ca
    cluster_name       = var.cluster_name
    bootstrap_args     = "--kubelet-extra-args --node-labels=node.kubernetes.io/nodegroup=${var.node_group_name},node.kubernetes.io/lifecycle=%{if var.node_launch_template_profile == "spot"}Ec2Spot%{else}OnDemand%{endif},node.cycloid.io/customer=${var.customer},node.cycloid.io/project=${var.project},node.cycloid.io/env=${var.env},eks.amazonaws.com/capacityType=%{if var.node_launch_template_profile == "spot"}SPOT%{else}ON_DEMAND%{endif},eks.amazonaws.com/nodegroup=${var.node_group_name},eks.amazonaws.com/nodegroup-image=${data.aws_ami.eks-node.id}"
  }
}

resource "aws_cloudformation_stack" "eks-node" {
  name = "${var.project}-${var.env}-eks-node-${var.node_group_name}"

  # "HealthCheckType": "ELB",
  # "TargetGroupARNs": ["${aws_alb_target_group.front-80.arn}"],
  # "HealthCheckGracePeriod": 600,
  template_body = <<EOF
{
  "Resources": {
    "EKSNodes${var.env}": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": ${jsonencode(local.aws_availability_zones)},
        "VPCZoneIdentifier": ${jsonencode(data.aws_subnet_ids.selected.ids)},
        "LaunchTemplate": {
            "LaunchTemplateId": "${local.node_launch_template_id}",
            "Version" : "${local.node_launch_template_latest_version}"
        },
        "DesiredCapacity": "${var.node_count}",
        "MinSize": "${var.node_asg_min_size}",
        "MaxSize": "${var.node_asg_max_size}",
        "TerminationPolicies": ["AllocationStrategy", "OldestLaunchTemplate", "OldestInstance"],
        "HealthCheckType": "EC2",
        "HealthCheckGracePeriod": 15,
        "MetricsCollection": [{
          "Granularity": "1Minute",
          "Metrics": ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
        }],
        "Tags" : ${jsonencode(local.node_tags)}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.node_launch_template_profile == "spot" ? 0 : var.node_update_min_in_service}",
          "MinSuccessfulInstancesPercent": "${var.node_launch_template_profile == "spot" ? 50 : 100}",
          "SuspendProcesses": ["ScheduledActions"],
          "MaxBatchSize": "1",
          "PauseTime": "PT8M",
          "WaitOnResourceSignals": "true"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
       "Value": {"Ref": "EKSNodes${var.env}"}
    }
  }
}
EOF

}
