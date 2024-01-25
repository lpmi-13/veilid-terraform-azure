resource "azurerm_network_security_group" "veilid-access" {
  name                = "veilid-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "tcp-5150-inbound"
    priority                     = 100
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5150"
    destination_address_prefixes = azurerm_subnet.internal.address_prefixes
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "tcp-5150-outbound"
    priority                     = 100
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5150"
    destination_address_prefixes = ["0.0.0.0/0"]
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "udp-5150-inbound"
    priority                     = 110
    protocol                     = "Udp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5150"
    destination_address_prefixes = azurerm_subnet.internal.address_prefixes
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "udp-5150-outbound"
    priority                     = 110
    protocol                     = "Udp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5150"
    destination_address_prefixes = ["0.0.0.0/0"]
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "tcp-5151-inbound"
    priority                     = 120
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5151"
    destination_address_prefixes = azurerm_subnet.internal.address_prefixes
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "tcp-5151-outbound"
    priority                     = 120
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5151"
    destination_address_prefixes = ["0.0.0.0/0"]
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "udp-5151-inbound"
    priority                     = 130
    protocol                     = "Udp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5151"
    destination_address_prefixes = azurerm_subnet.internal.address_prefixes
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "udp-5151-outbound"
    priority                     = 130
    protocol                     = "Udp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "5151"
    destination_address_prefixes = ["0.0.0.0/0"]
  }

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "ssh-access"
    priority                     = 140
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "22"
    destination_address_prefixes = azurerm_subnet.internal.address_prefixes
  }
}
