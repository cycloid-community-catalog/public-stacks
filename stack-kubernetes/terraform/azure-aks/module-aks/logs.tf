resource "azurerm_log_analytics_workspace" "aks-cluster" {
  count = var.enable_oms_agent ? 1 : 0

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days
}

resource "azurerm_log_analytics_solution" "aks-cluster" {
  count = var.enable_oms_agent ? 1 : 0

  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.aks-cluster[0].id
  workspace_name        = azurerm_log_analytics_workspace.aks-cluster[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}