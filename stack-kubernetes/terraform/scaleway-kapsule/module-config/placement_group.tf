resource "scaleway_instance_placement_group" "placement_group" {
  name        = var.placement_group_name
  policy_type = "max_availability"
  policy_mode = "optional"
  zone        = local.scw_zone
}