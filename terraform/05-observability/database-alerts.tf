# PostgreSQL Database Monitoring Alerts for Backstage
# These alerts monitor the health and performance of the Backstage PostgreSQL database

# Database CPU Usage Alert
resource "azurerm_monitor_metric_alert" "postgres_cpu" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "postgres-backstage-cpu-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.postgresql_server_name]

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when PostgreSQL CPU usage exceeds 85%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Database Memory Usage Alert
resource "azurerm_monitor_metric_alert" "postgres_memory" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "postgres-backstage-memory-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.postgresql_server_name]

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when PostgreSQL memory usage exceeds 85%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Database Storage Usage Alert
resource "azurerm_monitor_metric_alert" "postgres_storage" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "postgres-backstage-storage-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.postgresql_server_name]

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when PostgreSQL storage usage exceeds 80%"
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Database Connection Count Alert
resource "azurerm_monitor_metric_alert" "postgres_connections" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "postgres-backstage-connections-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.postgresql_server_name]

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 50 # Adjust based on connection pool size
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when PostgreSQL active connections exceed 50"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Database Availability Alert
resource "azurerm_monitor_metric_alert" "postgres_availability" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "postgres-backstage-availability-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.postgresql_server_name]

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "is_db_alive"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when PostgreSQL database is not responding"
  severity    = 1
  frequency   = "PT1M"
  window_size = "PT5M"

  tags = var.tags
}
