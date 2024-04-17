output "public_ip_address_ipv4" {
  value = [for ip in azurerm_public_ip.pip-ipv4 : ip.ip_address]
}

output "public_ip_address_ipv6" {
  value = [for ip in azurerm_public_ip.pip-ipv6 : ip.ip_address]
}
