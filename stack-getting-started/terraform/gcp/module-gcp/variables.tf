variable "project" {
  default = "snowy"
}

variable "env" {
  default = "demo"
}

variable "organization" {
  default = "cycloid"
}

variable "component" {
  default = "default"
}

locals {
  name_prefix = "${var.organization}-${var.project}-${var.env}-${var.component}"
}

variable "gcp_zone" {
  default = "europe-west1"
}

variable "gcp_project" {}

variable "instance_type" {
  default = "n1-standard-1"
}

