# Kubernetes
# In order to be able to connect to the EKS cluster
# we are creating
data "aws_eks_cluster_auth" "eks-cluster" {
  name = aws_eks_cluster.eks-cluster.id
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks-cluster.token
}