# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "avd" {
  name                = "${var.customer}-${var.project}-${var.env}-avd"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  friendly_name       = "${var.customer}-${var.project}-${var.env} Workspace"
  description         = "${var.customer}-${var.project}-${var.env} Workspace"
}