# Azure Container Instance Monitoring Alerts for Backstage (IDP)
# These alerts monitor the health and performance of the Backstage container

# Container CPU Usage Alert
resource "azurerm_monitor_metric_alert" "aci_cpu_usage" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "aci-backstage-cpu-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.container_group_name]

  criteria {
    metric_namespace = "Microsoft.ContainerInstance/containerGroups"
    metric_name      = "CpuUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0.8 # 80% of allocated CPU (1.0 core)
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when Backstage container CPU usage exceeds 80%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Container Memory Usage Alert
resource "azurerm_monitor_metric_alert" "aci_memory_usage" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "aci-backstage-memory-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.terraform_remote_state.idp[0].outputs.container_group_name]

  criteria {
    metric_namespace = "Microsoft.ContainerInstance/containerGroups"
    metric_name      = "MemoryUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1.7 # 85% of 2GB allocated memory
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when Backstage container memory usage exceeds 1.7GB (85%)"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Container Restart Alert (availability check)
resource "azurerm_monitor_activity_log_alert" "aci_restart" {
  count               = var.enable_idp_monitoring ? 1 : 0
  name                = "aci-backstage-restart-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  scopes              = [data.terraform_remote_state.idp[0].outputs.resource_group_id]

  criteria {
    resource_id    = data.terraform_remote_state.idp[0].outputs.container_group_name
    operation_name = "Microsoft.ContainerInstance/containerGroups/restart/action"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when Backstage container restarts unexpectedly"
  tags        = var.tags
}
