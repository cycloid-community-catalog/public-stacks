variable "resource_group_name" {}
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

variable "azure_location" {
  default = "francecentral"
}

variable "subnet_id" {}
variable "instance_type" {
  default = "Standard_DS1_v2"
}
