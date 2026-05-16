resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  count                 = var.enable_spot_node_pool ? 1 : 0
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.spot_vm_size
  os_disk_size_gb       = 128
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = -1

  enable_auto_scaling = true
  min_count           = 0
  max_count           = var.spot_max_count

  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
    "workload-type"                         = "batch"
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "aks_user_pool" {
  count               = var.enable_aks_autoscale_alerts ? 1 : 0
  name                = "aks-user-pool-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_kubernetes_cluster.main.agent_pool_profile[0].id

  profile {
    name = "default"

    capacity {
      default = var.node_count
      minimum = var.min_node_count
      maximum = var.max_node_count
    }

    rule {
      metric_trigger {
        metric_name        = "CpuUsagePercentage"
        metric_resource_id = azurerm_kubernetes_cluster.main.id
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
        metric_resource_id = azurerm_kubernetes_cluster.main.id
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
