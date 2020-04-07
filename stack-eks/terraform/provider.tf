# AWS
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

# Kubernetes
# In order to be able to connect to the EKS cluster
# we are creating
data "aws_eks_cluster_auth" "eks-cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.control_plane_endpoint
  cluster_ca_certificate = base64decode(module.eks.control_plane_ca)
  token                  = data.aws_eks_cluster_auth.eks-cluster.token
  load_config_file       = false
}