variable "access_key" {
}

variable "secret_key" {
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

#variable "vault_token" {}
#
#provider "vault" {
#  address = "https://vault.cycloid.io"
#  token   = "${var.vault_token}"
#}

variable "build_team_name" {
}

variable "build_pipeline_name" {
}

variable "project" {
}

variable "env" {
}

variable "customer" {
}
