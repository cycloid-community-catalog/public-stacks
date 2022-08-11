# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "avd" {
  name                     = "${var.customer}-${var.project}-${var.env}-avd"
  resource_group_name      = data.azurerm_resource_group.avd.name
  location                 = data.azurerm_resource_group.avd.location

  friendly_name            = "${var.customer}-${var.project}-${var.env} HostPool"
  description              = "${var.customer}-${var.project}-${var.env} HostPool"

  type                     = var.host_pool_type
  maximum_sessions_allowed = var.host_pool_max_sessions
  load_balancer_type       = var.host_pool_lb_type

  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  validate_environment     = true
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avd" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd.id
  expiration_date = var.host_pool_expiration_date
}