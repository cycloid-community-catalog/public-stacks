resource "aws_security_group" "eks-node" {
  name        = "${var.project}-${var.env}-eks-nodes"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name                                        = "${var.project}-${var.env}-eks-nodes"
    role                                        = "eks-node"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow nodes Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster-2" {
  description              = "Allow nodes Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-aws-lb" {
  description       = "Allow nodes to receive communication on service nodePorts from AWS Load Balancers"
  from_port         = 30000
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-node.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  to_port           = 32767
  type              = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster.id
  source_security_group_id = aws_security_group.eks-node.id
  to_port                  = 443
  type                     = "ingress"
}