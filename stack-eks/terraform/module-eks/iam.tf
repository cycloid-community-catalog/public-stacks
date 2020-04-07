#
# Control plane
#

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

resource "aws_iam_instance_profile" "eks-node" {
  name = "${var.project}-${var.env}-eks-node"
  role = aws_iam_role.eks-node.name
}
