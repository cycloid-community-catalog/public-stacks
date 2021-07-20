variable "resource_group_name" {}
variable "project" {
  default = "snowy"
}

variable "env" {
  default = "demo"
}

variable "customer" {
  default = "cycloid"
}

variable "azure_location" {
  default = "francecentral"
}

variable "subnet_id" {}
variable "instance_type" {
  default = "Standard_DS1_v2"
}
