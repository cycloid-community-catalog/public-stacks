resource "azurerm_network_security_group" "aks-nodes" {
  name                = "${var.project}-${var.env}-nodes"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = length(var.ssh_allowed_ips) == 1 ? var.ssh_allowed_ips[0] : null
    source_address_prefixes    = length(var.ssh_allowed_ips) > 1 ? var.ssh_allowed_ips : null
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-metrics"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefix      = length(var.metrics_allowed_ips) == 1 ? var.metrics_allowed_ips[0] : null
    source_address_prefixes    = length(var.metrics_allowed_ips) > 1 ? var.metrics_allowed_ips : null
    destination_address_prefix = "*"
  }

  tags = merge(local.merged_tags, {
    name = "${var.project}-${var.env}-nodes"
  })

  depends_on = [
    module.azure-network
  ]
}