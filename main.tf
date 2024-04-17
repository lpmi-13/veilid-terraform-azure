
resource "azurerm_resource_group" "main" {
  name     = "veilid-${local.region}-resources"
  location = local.region
}

resource "azurerm_virtual_network" "main" {
  name                = "veilid-network"
  address_space       = ["10.0.0.0/16", "2600:db8:deca::/48"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "veilid-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24", "2600:db8:deca::/64"]
}


resource "azurerm_public_ip" "pip-ipv4" {
  count               = local.instance_count
  name                = "veilid-pip-ipv4-${count.index}"
  ip_version          = "IPv4"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip-ipv6" {
  count               = local.instance_count
  name                = "veilid-pip-ipv6-${count.index}"
  ip_version          = "IPv6"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "main" {
  count               = local.instance_count
  name                = "veilid-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    primary                       = true
    name                          = "primary-ipv4"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-ipv4[count.index].id
  }

  ip_configuration {
    name                          = "primary-ipv6"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
    public_ip_address_id          = azurerm_public_ip.pip-ipv6[count.index].id
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.veilid-access.id
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
