#
# Spot
#

resource "aws_launch_template" "eks-node-spot" {
  name_prefix   = "${var.project}-${var.env}-eks-node-${var.node_group_name}-spot-version_"
  image_id      = data.aws_ami.eks-node.id
  instance_type = var.node_type
  user_data     = base64encode(data.template_file.user-data-eks-node.rendered)
  key_name      = var.keypair_name

  instance_market_options {
    market_type = "spot"

    spot_options {
      spot_instance_type = var.node_spot_request_type != "" ? var.node_spot_request_type : null
      max_price          = var.node_spot_price != "" ? var.node_spot_price : null
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  network_interfaces {
    associate_public_ip_address = var.node_associate_public_ip_address
    delete_on_termination       = true

    security_groups = compact(
      [
        aws_security_group.eks-node.id,
        var.node_sg_id,
        var.bastion_sg_allow,
        var.metrics_sg_allow,
      ],
    )
  }

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = var.node_iam_instance_profile_name
  }

  tags = merge(local.merged_tags, {
    Name                                        = "${var.project}-${var.env}-eks-node-${var.node_group_name}-template"
    role                                        = "eks-node-template"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/nodegroup/name"              = var.node_group_name
    "eks:cluster-name"                          = var.cluster_name
    "eks:nodegroup-name"                        = var.node_group_name
  })

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.merged_tags, {
      Name                                        = "${var.project}-${var.env}-eks-node-${var.node_group_name}"
      role                                        = "eks-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "kubernetes.io/nodegroup/name"              = var.node_group_name
      "eks:cluster-name"                          = var.cluster_name
      "eks:nodegroup-name"                        = var.node_group_name
    })
  }
  tag_specifications {
    resource_type = "volume"

    tags = merge(local.merged_tags, {
      Name                                        = "${var.project}-${var.env}-eks-node-${var.node_group_name}"
      role                                        = "eks-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "kubernetes.io/nodegroup/name"              = var.node_group_name
      "eks:cluster-name"                          = var.cluster_name
      "eks:nodegroup-name"                        = var.node_group_name
    })
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.node_disk_size
      volume_type           = var.node_disk_type
      delete_on_termination = true
    }
  }
  ebs_optimized = var.node_ebs_optimized
}
