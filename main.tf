
resource "azurerm_resource_group" "main" {
  name     = "veilid-${local.region}-resources"
  location = local.region
}

resource "azurerm_linux_virtual_machine" "main" {
  count               = local.instance_count
  name                = "veilid-node-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = local.instance_size
  admin_username      = "veilid"

  user_data = base64encode(file("./setup-veilid.yaml"))

  admin_ssh_key {
    username = "veilid"
    # only RSA keys are supported, so make sure the key you use here is one of those
    public_key = file("./PATH_TO_YOUR_PRIVATE_SSH_KEY")
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    # you have to specify this exact disk size to get the setting that qualifies for the free tier.
    disk_size_gb         = 64
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }
}
