data "aws_region" "current" {}

variable "env" {}
variable "organization" {}

variable "component" {
  default = "default"
}

locals {
  name_prefix = "${var.organization}-${var.project}-${var.env}-${var.component}"
}

variable "keypair_name" {
  default = "demo"
}

variable "project" {
  default = "cycloid"
}

variable "instance_type" {
  default = "t3.small"
}
