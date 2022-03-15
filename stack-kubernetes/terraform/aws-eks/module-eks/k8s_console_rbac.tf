# ref. https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

resource "kubernetes_cluster_role" "eks-console-dashboard-full-access" {
  metadata {
    name = "eks-console-dashboard-full-access-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "eks-console-dashboard-full-access" {
  metadata {
    name = "eks-console-dashboard-full-access-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "eks-console-dashboard-full-access-clusterrole"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "eks-console-dashboard-full-access-group"
  }
}

resource "kubernetes_cluster_role" "eks-console-dashboard-restricted-access" {
  metadata {
    name = "eks-console-dashboard-restricted-access-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "eks-console-dashboard-restricted-access-clusterrole" {
  metadata {
    name = "eks-console-dashboard-restricted-access-clusterrole-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "eks-console-dashboard-restricted-access-clusterrole"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "eks-console-dashboard-restricted-access-group"
  }
}

resource "kubernetes_role" "eks-console-dashboard-restricted-access-default" {
  metadata {
    name      = "eks-console-dashboard-restricted-access-role"
    namespace = "default"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding" "eks-console-dashboard-restricted-access-role-default" {
  metadata {
    name      = "eks-console-dashboard-restricted-access-role-binding"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "eks-console-dashboard-restricted-access-role"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "eks-console-dashboard-restricted-access-group"
  }
}

