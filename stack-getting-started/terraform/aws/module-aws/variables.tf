data "aws_region" "current" {}

variable "env" {}
variable "organization" {}

variable "keypair_name" {
  default = "demo"
}

variable "project" {
  default = "cycloid"
}

variable "instance_type" {
  default = "t3.small"
}
