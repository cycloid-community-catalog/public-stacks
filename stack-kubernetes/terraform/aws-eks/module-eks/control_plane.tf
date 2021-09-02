#
# Security Groups
#

resource "aws_security_group" "eks-cluster" {
  name        = "${var.project}-${var.env}-eks-cluster"
  description = "Cluster communication with nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name                                        = "${var.project}-${var.env}-eks-cluster"
    role                                        = "eks-control-plane"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

# Allow inbound traffic from external IPs to the Kubernetes API.
resource "aws_security_group_rule" "eks-cluster-ingress-external-ips-https" {
  cidr_blocks       = var.control_plane_allowed_ips
  description       = "Allow external IPs to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

#
# EKS Cluster
#

resource "aws_eks_cluster" "eks-cluster" {
  name                      = var.cluster_name
  version                   = var.cluster_version
  role_arn                  = aws_iam_role.eks-cluster.arn
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    security_group_ids = compact([
      aws_security_group.eks-cluster.id,
      var.metrics_sg_allow
    ])
    subnet_ids = var.public_subnets_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.eks-cluster,
  ]
}

resource "aws_cloudwatch_log_group" "eks-cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}