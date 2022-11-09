# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#default-roles-and-role-bindings

# bootstrappers & nodes
# Apply the aws-authConfigMap to your cluster to allow nodes to join your cluster
# https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html#aws-auth-configmap

# map admin_iam_role to k8s cluster admin
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<MAPROLES
        - rolearn: ${aws_iam_role.eks-node.arn}
          username: system:node:{{EC2PrivateDNSName}}
          groups:
            - system:bootstrappers
            - system:nodes
        - rolearn: ${local.k8s_eks_admin_iam_role_arn}
          username: admin
          groups:
            - system:masters
MAPROLES
  }

  depends_on = [
    aws_iam_role.eks-node,
    aws_eks_cluster.eks-cluster,
  ]
}
