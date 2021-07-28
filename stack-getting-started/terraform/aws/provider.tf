variable "customer" {}
variable "project" {}
variable "env" {}

# Aws
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
  default_tags {
    tags = {
      "cycloid.io" = "true"
      env          = var.env
      project      = var.project
      customer     = var.customer
      organization = var.customer
    }
  }
}
variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}
