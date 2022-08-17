# Create Network Security Group
resource "azurerm_network_security_group" "cycloid-worker" {
  name                = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  resource_group_name = data.azurerm_resource_group.cycloid-worker.name
  location            = var.azure_location

  security_rule {
    name                       = "inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  })
}

# Get a Static Public IP
resource "azurerm_public_ip" "cycloid-worker" {
  name                = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  resource_group_name = data.azurerm_resource_group.cycloid-worker.name
  location            = var.azure_location
  allocation_method   = "Dynamic"

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  })
}

# Create Network Card for the VM
resource "azurerm_network_interface" "cycloid-worker" {
  name                = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  resource_group_name = data.azurerm_resource_group.cycloid-worker.name
  location            = var.azure_location

  ip_configuration {
      name                          = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
      subnet_id                     = azurerm_subnet.cycloid-worker.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.cycloid-worker.id
  }

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  })
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "cycloid-worker" {
    network_interface_id      = azurerm_network_interface.cycloid-worker.id
    network_security_group_id = azurerm_network_security_group.cycloid-worker.id
}

resource "azurerm_virtual_network" "cycloid-worker" {
  name                = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  resource_group_name = data.azurerm_resource_group.cycloid-worker.name
  location            = var.azure_location
  address_space       = ["10.0.0.0/16"]

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  })
}

resource "azurerm_subnet" "cycloid-worker" {
  name                 = "${var.customer}-${var.project}-${var.env}-cycloid-worker-subnet"
  virtual_network_name = azurerm_virtual_network.cycloid-worker.name
  resource_group_name  = data.azurerm_resource_group.cycloid-worker.name

  address_prefixes     = ["10.0.1.0/24"]
}