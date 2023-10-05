#
# Dedicated VPC
#

module "azure-network" {
  source  = "Azure/network/azurerm"

  resource_group_name = var.resource_group_name

  vnet_name           = "${var.project}-${var.env}-vnet"
  address_space       = var.address_space
  subnet_prefixes     = [ for name, prefix in var.subnets: prefix ]
  subnet_names        = [ for name, prefix in var.subnets: name ]

  tags = merge(local.merged_tags, {
    name = "${var.project}-${var.env}-vnet"
  })
}

resource "azurerm_subnet" "aks" {
  for_each = var.subnets

  name                      = each.key
  address_prefixes          = [ each.value ]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.azure-network.vnet_name
}

resource "azurerm_subnet_network_security_group_association" "aks-nodes" {
  subnet_id                 = azurerm_subnet.aks["nodes"].id
  network_security_group_id = azurerm_network_security_group.aks-nodes.id
}