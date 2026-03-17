resource "azurerm_monitor_metric_alert" "postgresql_cpu" {
  count               = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-postgresql-cpu-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "postgresql_storage" {
  count               = var.enable_postgresql && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-postgresql-storage-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  severity            = 1
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  tags = local.common_tags
}
