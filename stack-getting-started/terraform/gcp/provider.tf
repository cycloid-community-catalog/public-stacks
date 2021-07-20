variable "customer" {}
variable "project" {}
variable "env" {}

# GCP
provider "google" {
  version = "~> 2.18.0"
  project = var.gcp_project
}
variable "gcp_project" {
  default = "cycloid-demo"
}
variable "gcp_zone" {
  default = "europe-west1-b"
}
