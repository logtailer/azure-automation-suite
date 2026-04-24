resource "azurerm_postgresql_flexible_server_configuration" "ssl_min_version" {
  count     = var.enable_postgresql ? 1 : 0
  name      = "ssl_min_protocol_version"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "TLSv1.2"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  count     = var.enable_postgresql ? 1 : 0
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_disconnections" {
  count     = var.enable_postgresql ? 1 : 0
  name      = "log_disconnections"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "connection_throttle" {
  count     = var.enable_postgresql ? 1 : 0
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_checkpoints" {
  count     = var.enable_postgresql ? 1 : 0
  name      = "log_checkpoints"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "on"
}
