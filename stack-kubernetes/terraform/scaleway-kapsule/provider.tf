# Scaleway
provider "scaleway" {
  access_key      = var.scw_access_key
  secret_key      = var.scw_secret_key
  region          = var.scw_region
  zone            = local.scw_zone
  organization_id = var.scw_organization_id
}