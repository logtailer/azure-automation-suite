resource "azurerm_monitor_diagnostic_setting" "postgresql" {
  count                      = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                       = "diag-${var.postgresql_server_name}"
  target_resource_id         = azurerm_postgresql_flexible_server.main[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "PostgreSQLLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "redis" {
  count                      = var.enable_redis && var.log_analytics_workspace_id != "" ? 1 : 0
  name                       = "diag-${var.redis_cache_name}"
  target_resource_id         = azurerm_redis_cache.main[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ConnectedClientList"
  }
}
