# Infrastructure Monitoring Alerts

# AKS Cluster Health Alert
resource "azurerm_monitor_metric_alert" "aks_node_health" {
  name                = "aks-node-health-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.aks_cluster_id]

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "kube_node_status_condition"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1

    dimension {
      name     = "condition"
      operator = "Include"
      values   = ["Ready"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when AKS nodes are not ready"
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Memory Usage Alert for AKS
resource "azurerm_monitor_metric_alert" "aks_memory_usage" {
  name                = "aks-memory-usage-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.aks_cluster_id]

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_memory_working_set_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when AKS node memory usage exceeds 85%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# CPU Usage Alert for AKS
resource "azurerm_monitor_metric_alert" "aks_cpu_usage" {
  name                = "aks-cpu-usage-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.aks_cluster_id]

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when AKS node CPU usage exceeds 90%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Storage Account Health Alert
resource "azurerm_monitor_metric_alert" "storage_availability" {
  name                = "storage-availability-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.storage_account_id]

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when storage availability drops below 99%"
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Application Insights Availability Alert
resource "azurerm_monitor_metric_alert" "app_availability" {
  name                = "app-availability-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_application_insights.main.id]

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 95
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when application availability drops below 95%"
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Response Time Alert
resource "azurerm_monitor_metric_alert" "response_time" {
  name                = "response-time-alert"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_application_insights.main.id]

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5000 # 5 seconds
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  description = "Alert when average response time exceeds 5 seconds"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}
