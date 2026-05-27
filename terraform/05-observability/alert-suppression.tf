resource "azurerm_monitor_alert_processing_rule_suppression" "maintenance_window" {
  count               = var.enable_maintenance_suppression ? 1 : 0
  name                = "suppress-during-maintenance"
  resource_group_name = var.resource_group_name
  enabled             = false

  scopes = [
    "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  ]

  condition {
    target_resource_type {
      operator = "Equals"
      values   = ["Microsoft.ContainerService/managedClusters", "Microsoft.Compute/virtualMachines"]
    }
    severity {
      operator = "Equals"
      values   = ["Sev2", "Sev3", "Sev4"]
    }
  }

  schedule {
    time_zone = "UTC"
    recurrence {
      weekly {
        days_of_week = ["Saturday", "Sunday"]
        start_time   = "02:00:00"
        end_time     = "06:00:00"
      }
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_alert_processing_rule_action_group" "route_critical" {
  count               = var.enable_alert_routing ? 1 : 0
  name                = "route-critical-to-oncall"
  resource_group_name = var.resource_group_name
  enabled             = true

  scopes = [
    "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  ]

  condition {
    severity {
      operator = "Equals"
      values   = ["Sev0", "Sev1"]
    }
  }

  add_action_group_ids = [var.critical_action_group_id]

  tags = var.tags
}
