variable "env" {
}

variable "project" {
  default = "s3"
}

variable "customer" {
}

variable "bucket_name" {
}

variable "bucket_acl" {
  default = "private"
}

variable "versioning_enabled" {
  default = false
}

variable "extra_tags" {
  default = {}
}


locals {
  standard_tags = {
    client       = var.customer
    env          = var.env
    project      = var.project
    "cycloid.io" = "true"
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}
