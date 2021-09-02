# GCP
provider "google" {
}

provider "google-beta" {
}

# Kubernetes
data "google_client_config" "default" {
}

provider "kubernetes" {
  host                   = module.gke.cluster_endpoint
  cluster_ca_certificate = base64decode(module.gke.cluster_ca)
  token                  = data.google_client_config.default.access_token
}