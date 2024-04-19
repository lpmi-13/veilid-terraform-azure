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
  count               = local.needIpv4 ? local.instance_count : 0
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
    name                          = "ipv4-address"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = local.needIpv4 ? azurerm_public_ip.pip-ipv4[count.index].id : null
  }

  ip_configuration {
    name                          = "ipv6-address"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
    public_ip_address_id          = azurerm_public_ip.pip-ipv6[count.index].id
  }
}

resource "azurerm_subnet_network_security_group_association" "veilid" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.veilid-access.id
}
