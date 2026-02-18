resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  count            = var.enable_postgresql && var.allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.main[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allowed_ips" {
  for_each         = var.enable_postgresql ? var.postgresql_allowed_ip_ranges : {}
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.main[0].id
  start_ip_address = each.value.start
  end_ip_address   = each.value.end
}
