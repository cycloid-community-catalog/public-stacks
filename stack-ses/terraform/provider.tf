provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
  version    = "~> 2.32"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

