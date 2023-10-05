# Cycloid
variable "project" {
  default = "external-worker"
}
variable "customer" {
}
variable "env" {
}

# Scaleway
variable "scw_region" {
}

variable "scw_instance_disk_size" {
  type = map(number)

  default = {
    "DEV1-S"  = 20
    "DEV1-M"  = 40
    "DEV1-L"  = 80
    "DEV1-XL" = 120
    "GP1-XS"  = 150
    "GP1-S"   = 300
    "GP1-M"   = 600
    "GP1-L"   = 600
    "GP1-XL"  = 600
  }
}

variable "extra_tags" {
  default = []
}

locals {
  standard_tags = [
    "cycloid.io=true",
    "env=${var.env}",
    "project=${var.project}",
    "client=${var.customer}",
  ]
  merged_tags = compact(concat(local.standard_tags, var.extra_tags))
}

variable "ssh_allowed_ips" {
  default = []
}

variable "metrics_allowed_ips" {
  default = []
}

#
# worker
#
variable "worker_count" {
}

variable "worker_type" {
  default = "GP1-XS"
}

variable "worker_image_id" {
  default = ""
}

variable "worker_volume_disk_size" {
  default = "0"
}

variable "worker_volume_disk_type" {
  default = "l_ssd"
}

