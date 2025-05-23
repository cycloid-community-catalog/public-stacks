variable "organization" {}
variable "project" {}
variable "env" {}
variable "component" {}

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
variable "gcp_region" {
  description = "GCP region to launch vm."
  default     = "europe-west1"
}
