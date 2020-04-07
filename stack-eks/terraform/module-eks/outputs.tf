output "cluster_name" {
  description = "EKS Cluster name."
  value       = aws_eks_cluster.eks-cluster.id
}

output "cluster_version" {
  description = "EKS Cluster version."
  value       = aws_eks_cluster.eks-cluster.version
}

output "cluster_platform_version" {
  description = "EKS Cluster plateform version."
  value       = aws_eks_cluster.eks-cluster.platform_version
}

output "control_plane_sg_id" {
  description = "EKS Cluster Security Group ID."
  value       = aws_security_group.eks-cluster.id
}

output "control_plane_endpoint" {
  description = "EKS Cluster endpoint."
  value       = aws_eks_cluster.eks-cluster.endpoint
}

output "control_plane_ca" {
  description = "EKS Cluster certificate authority."
  value       = aws_eks_cluster.eks-cluster.certificate_authority.0.data
}

output "control_plane_openid_issuer_url" {
  description = "EKS Cluster OpenID Connect issuer URL."
  value       = aws_eks_cluster.eks-cluster.identity.0.oidc.0.issuer
}

output "node_iam_role_arn" {
  description = "EKS nodes IAM role ARN."
  value       = aws_iam_role.eks-node.arn
}

output "node_iam_instance_profile_name" {
  description = "EKS nodes IAM instance profile name."
  value       = aws_iam_instance_profile.eks-node.name
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-cluster.certificate_authority.0.data}
  name: eks-${var.cluster_name}
contexts:
- context:
    cluster: eks-${var.cluster_name}
    user: aws-${var.cluster_name}
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
kind: Config
preferences: {}
users:
- name: aws-${var.cluster_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the EKS Cluster."
  value       = local.kubeconfig
}
