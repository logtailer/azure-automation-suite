output "appgw_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.main.id
}

output "public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw.ip_address
}
