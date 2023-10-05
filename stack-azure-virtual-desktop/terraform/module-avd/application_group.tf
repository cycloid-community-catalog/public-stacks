# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "avd" {
  name                = "${var.customer}-${var.project}-${var.env}-avd"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd.id
  friendly_name       = "${var.customer}-${var.project}-${var.env} AppGroup"
  description         = "${var.customer}-${var.project}-${var.env} AppGroup"
  type                = var.app_group_type

  depends_on          = [azurerm_virtual_desktop_host_pool.avd, azurerm_virtual_desktop_workspace.avd]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "avd" {
  application_group_id = azurerm_virtual_desktop_application_group.avd.id
  workspace_id         = azurerm_virtual_desktop_workspace.avd.id
}
