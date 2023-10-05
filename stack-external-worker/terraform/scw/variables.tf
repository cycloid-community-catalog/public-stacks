# Cycloid requirements
variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

# Scaleway
variable "scw_access_key" {
}

variable "scw_secret_key" {
}

variable "scw_organization_id" {
}

variable "scw_region" {
  description = "Scaleway region to launch servers."
  default     = "fr-par"
}

variable "scw_zone_id" {
  description = "Scaleway region's zone ID to launch servers."
  default     = "1"
}

locals {
  scw_zone = "${var.scw_region}-${var.scw_zone_id}"
}

# Stack
variable "worker_image_id" {
  default = ""
}

