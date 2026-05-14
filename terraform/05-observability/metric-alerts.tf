resource "azurerm_monitor_metric_alert" "aks_node_cpu" {
  count               = var.enable_aks_alerts ? 1 : 0
  name                = "aks-node-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "AKS node CPU utilisation above threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.aks_cpu_alert_threshold
  }

  action {
    action_group_id = var.warning_action_group_id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "aks_node_memory" {
  count               = var.enable_aks_alerts ? 1 : 0
  name                = "aks-node-memory-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "AKS node memory working set above threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_memory_working_set_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.aks_memory_alert_threshold
  }

  action {
    action_group_id = var.warning_action_group_id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "aks_pod_failed" {
  count               = var.enable_aks_alerts ? 1 : 0
  name                = "aks-pod-failed-state"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "AKS pods in failed state"
  severity            = 1
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "kube_pod_status_phase"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "phase"
      operator = "Include"
      values   = ["Failed"]
    }
  }

  action {
    action_group_id = var.critical_action_group_id
  }

  tags = var.tags
}
