resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure" {
  count               = var.enable_mysql && var.allow_azure_services ? 1 : 0
  name                = "AllowAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main[0].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "custom" {
  for_each            = var.enable_mysql ? var.mysql_allowed_ip_ranges : {}
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main[0].name
  start_ip_address    = each.value.start
  end_ip_address      = each.value.end
}

resource "azurerm_mysql_flexible_server_configuration" "require_ssl" {
  count               = var.enable_mysql ? 1 : 0
  name                = "require_secure_transport"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main[0].name
  value               = "ON"
}

resource "azurerm_mysql_flexible_server_configuration" "tls_version" {
  count               = var.enable_mysql ? 1 : 0
  name                = "tls_version"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main[0].name
  value               = "TLSv1.2,TLSv1.3"
}
