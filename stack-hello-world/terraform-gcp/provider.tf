provider "google" {
  credentials = "${var.gcp_credentials}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

variable "gcp_credentials" {}
variable "gcp_project" {}
variable "gcp_region" {}
variable "customer" {}
variable "project" {}
variable "env" {}

variable "bucket_name" {}

variable "bucket_object_path" {}
