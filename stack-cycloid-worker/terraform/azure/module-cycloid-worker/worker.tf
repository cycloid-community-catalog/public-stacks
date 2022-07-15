# Create Worker VM
resource "azurerm_linux_virtual_machine" "cycloid-worker" {
  name                  = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  resource_group_name   = data.azurerm_resource_group.cycloid-worker.name
  location              = data.azurerm_resource_group.cycloid-worker.location
  network_interface_ids = [azurerm_network_interface.cycloid-worker.id]
  size                  = var.vm_instance_type
  admin_username        = var.vm_os_user

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
      publisher = "Debian"
      offer     = "debian-10"
      sku       = "10"
      version   = "latest"
  }

  disable_password_authentication = true

  admin_ssh_key {
      username   = var.vm_os_user
      public_key = var.keypair_public
  }

  custom_data = base64encode(templatefile(
    "${path.module}/userdata.sh.tpl",
    {
      TEAM_ID = var.team_id
      WORKER_KEY = base64encode(var.worker_key)
    }
  ))

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
    role = "cycloid-worker"
  })
}