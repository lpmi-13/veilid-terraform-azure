output "public_ip_address" {
  value = [for ip in azurerm_public_ip.pip : ip.ip_address]
}
