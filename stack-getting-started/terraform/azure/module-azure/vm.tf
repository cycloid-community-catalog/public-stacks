resource "azurerm_public_ip" "main" {
  name                = "${local.name_prefix}-ip"
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  allocation_method   = "Static"

  tags = {
    environment  = var.env
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    component    = var.component
  }

}

resource "azurerm_network_interface" "main" {
  name                = "${local.name_prefix}-nic"
  location            = var.azure_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = local.name_prefix
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
    primary                       = true
  }
  tags = {
    environment  = var.env
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    component    = var.component
  }

}

// data "template_file" "user_data" {
//   template = file("${path.module}/userdata.sh.tpl")
//
//   vars = {
//     env             = var.env
//     project         = var.project
//   }
// }

resource "random_string" "password" {
  length           = 16
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%@"
}

resource "azurerm_virtual_machine" "main" {
  name                  = local.name_prefix
  location              = var.azure_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.instance_type

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.name_prefix}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "demo"
    admin_username = "cycloid"
    admin_password = random_string.password.result
    // custom_data    = data.template_file.user_data.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment  = var.env
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    component    = var.component
  }
}
