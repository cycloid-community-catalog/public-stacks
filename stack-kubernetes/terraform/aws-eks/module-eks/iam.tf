#
# Control plane
#

# Role

resource "aws_iam_role" "eks-cluster" {
  name = "${var.project}-${var.env}-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# EKS policies

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster.name
}

#
# Node
#

# Role

resource "aws_iam_role" "eks-node" {
  name = "${var.project}-${var.env}-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# EKS policies

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

# ECR

data "aws_iam_policy_document" "eks-node-ecr-pull" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks-node-ecr-pull" {
  name        = "${var.project}-${var.env}-eks-node-ecr-pull"
  path        = "/"
  description = "EKS nodes ECR pull access"
  policy      = data.aws_iam_policy_document.eks-node-ecr-pull.json
}

resource "aws_iam_role_policy_attachment" "eks-node-ecr-pull" {
  policy_arn = aws_iam_policy.eks-node-ecr-pull.arn
  role       = aws_iam_role.eks-node.name
}

# Cluster autoscaler

data "aws_iam_policy_document" "eks-node-cluster-autoscaler" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks-node-cluster-autoscaler" {
  name        = "${var.project}-${var.env}-eks-node-cluster-autoscaler"
  path        = "/"
  description = "EKS nodes Cluster Autoscaler"
  policy      = data.aws_iam_policy_document.eks-node-cluster-autoscaler.json
}

resource "aws_iam_role_policy_attachment" "eks-node-cluster-autoscaler" {
  policy_arn = aws_iam_policy.eks-node-cluster-autoscaler.arn
  role       = aws_iam_role.eks-node.name
}

# CloudFormation signal

data "aws_iam_policy_document" "cloudformation-signal" {
  statement {
    actions = [
      "cloudformation:SignalResource",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/${var.project}-*-eks-node-*/*",
    ]
  }
}

resource "aws_iam_policy" "cloudformation-signal" {
  name        = "${var.project}-${var.env}-cloudformation-signal"
  path        = "/"
  description = "Allow to send stack signal from EKS nodes"
  policy      = data.aws_iam_policy_document.cloudformation-signal.json
}

resource "aws_iam_role_policy_attachment" "cloudformation-signal" {
  policy_arn = aws_iam_policy.cloudformation-signal.arn
  role       = aws_iam_role.eks-node.name
}

# Amazon EBS CSI driver

data "aws_iam_policy_document" "ebs-csi-driver" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:ModifyVolume"
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ebs-csi-driver" {
  name        = "${var.project}-${var.env}-ebs-csi-driver"
  path        = "/"
  description = "Allows Amazon EKS clusters to manage the lifecycle of Amazon EBS volumes for persistent volumes"
  policy      = data.aws_iam_policy_document.ebs-csi-driver.json
}

resource "aws_iam_role_policy_attachment" "ebs-csi-driver" {
  policy_arn = aws_iam_policy.ebs-csi-driver.arn
  role       = aws_iam_role.eks-node.name
}

# Instance profile

resource "aws_iam_instance_profile" "eks-node" {
  name = "${var.project}-${var.env}-eks-node"
  role = aws_iam_role.eks-node.name
}