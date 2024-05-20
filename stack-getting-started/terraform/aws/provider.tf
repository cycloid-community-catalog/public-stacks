variable "organization" {}
variable "project" {}
variable "env" {}

# Aws
provider "aws" {
  access_key = var.aws_access_cred.access_key
  secret_key = var.aws_access_cred.secret_key
  region     = var.aws_region
  default_tags {
    tags = {
      "cycloid.io" = "true"
      env          = var.env
      project      = var.project
      organization = var.organization
    }
  }
}

variable "aws_access_cred" {}
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}
