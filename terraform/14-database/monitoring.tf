resource "azurerm_monitor_metric_alert" "postgres_cpu" {
  count               = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-postgres-cpu-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }
}

resource "azurerm_monitor_metric_alert" "postgres_storage" {
  count               = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-postgres-storage-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  severity            = 1
  frequency           = "PT15M"
  window_size         = "PT1H"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }
}

resource "azurerm_monitor_metric_alert" "postgres_connections" {
  count               = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-postgres-connections-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.postgres_max_connections_alert_threshold
  }
}
