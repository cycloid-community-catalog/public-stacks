variable "customer" {}
variable "project" {}
variable "env" {}

terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 2.18.0"
    }
  }
}

# GCP
provider "google" {
  project = var.gcp_project
}
variable "gcp_project" {
  default = "cycloid-demo"
}
variable "gcp_zone" {
  default = "europe-west1-b"
}
