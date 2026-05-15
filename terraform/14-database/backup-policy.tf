resource "azurerm_postgresql_flexible_server_configuration" "backup_retention" {
  count     = var.enable_database ? 1 : 0
  name      = "backup_retention_days"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = tostring(var.db_backup_retention_days)
}

resource "azurerm_postgresql_flexible_server_configuration" "wal_level" {
  count     = var.enable_database ? 1 : 0
  name      = "wal_level"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "replica"
}

resource "azurerm_postgresql_flexible_server_configuration" "max_wal_senders" {
  count     = var.enable_database ? 1 : 0
  name      = "max_wal_senders"
  server_id = azurerm_postgresql_flexible_server.main[0].id
  value     = "10"
}

resource "azurerm_monitor_metric_alert" "db_storage_backup" {
  count               = var.enable_database && var.enable_db_alerts ? 1 : 0
  name                = "pg-backup-storage-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_flexible_server.main[0].id]
  description         = "PostgreSQL backup storage consumption high"
  severity            = 2
  frequency           = "PT1H"
  window_size         = "PT6H"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "backup_storage_used"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.db_backup_storage_alert_gb * 1073741824
  }

  action {
    action_group_id = var.warning_action_group_id
  }

  tags = var.tags
}
