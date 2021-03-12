#
# Cycloid
#

variable project {
  type        = string
  description = "Cycloid project name."
}

variable env {
  type        = string
  description = "Cycloid environment name."
}

variable customer {
  type        = string
  description = "Cycloid customer name."
}

#
# Scaleway
#

variable scw_access_key {
  type        = string
  description = "Scaleway access key."
}

variable scw_secret_key {
  type        = string
  description = "Scaleway secret key."
}

variable scw_organization_id {
  type        = string
  description = "Scaleway organization ID."
}

variable scw_region {
  type        = string
  description = "Scaleway region to create resources."
  default     = "fr-par"
}

variable scw_zone_id {
  type        = string
  description = "Scaleway region's zone ID to create resources."
  default     = "1"
}

locals {
  scw_zone = "${var.scw_region}-${var.scw_zone_id}"
}

#
# Stack
#

locals {
  kapsule_cluster_name = length(local.cluster_name) > 0 ? local.cluster_name : "${var.project}-${var.env}"
}
