resource "azurerm_monitor_autoscale_setting" "aks_user_pool" {
  count               = var.enable_aks_autoscale_alerts ? 1 : 0
  name                = "aks-user-pool-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_kubernetes_cluster_node_pool.user_node_pool.id

  profile {
    name = "default"

    capacity {
      default = var.default_node_count
      minimum = var.node_pool_min_count
      maximum = var.node_pool_max_count
    }

    rule {
      metric_trigger {
        metric_name        = "CpuUsagePercentage"
        metric_resource_id = azurerm_kubernetes_cluster.cluster.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuUsagePercentage"
        metric_resource_id = azurerm_kubernetes_cluster.cluster.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }

  tags = var.tags
}
