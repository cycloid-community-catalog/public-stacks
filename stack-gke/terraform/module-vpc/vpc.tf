#
# Dedicated VPC
#

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 1.5.0"

  project_id   = var.gcp_project
  network_name = "${var.project}-gke-${var.env}"
  routing_mode = var.network_routing_mode

  subnets = [
    {
      subnet_name           = "${var.project}-gke-${var.env}-${var.gcp_region}"
      subnet_ip             = var.subnet_cidr
      subnet_region         = var.gcp_region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    "${var.project}-gke-${var.env}-${var.gcp_region}" = [
      {
        range_name    = "${var.project}-gke-${var.env}-${var.gcp_region}-pods"
        ip_cidr_range = var.pods_cidr
      },
      {
        range_name    = "${var.project}-gke-${var.env}-${var.gcp_region}-services"
        ip_cidr_range = var.services_cidr
      },
    ]
  }

  # routes = [
  #   {
  #     name              = "${var.project}-gke-${var.env}-${var.gcp_region}-egress-inet"
  #     description       = "route through IGW to access internet"
  #     destination_range = "0.0.0.0/0"
  #     tags              = "egress-inet"
  #     next_hop_internet = "true"
  #   },
  # ]
}

#
# Cloud NAT
#

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 1.3.0"
  
  project_id    = var.gcp_project
  region        = var.gcp_region
  create_router = "true"
  router        = "${var.project}-gke-${var.env}-${var.gcp_region}-cloud-nat"
  network       = module.gcp-network.network_name
}
