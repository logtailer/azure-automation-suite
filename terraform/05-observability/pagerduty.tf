# PagerDuty Integration for On-Call Management
# Requires PagerDuty provider and integration key

# PagerDuty webhook action for Azure Monitor
resource "azurerm_monitor_action_group" "pagerduty" {
  count               = var.enable_pagerduty_integration ? 1 : 0
  name                = "pagerduty-action-group"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "pagerduty"

  webhook_receiver {
    name        = "pagerduty-webhook"
    service_uri = var.pagerduty_webhook_url
    use_common_alert_schema = true
  }

  tags = var.tags
}

# Critical alerts routed to PagerDuty
resource "azurerm_monitor_metric_alert" "critical_service_down" {
  count               = var.enable_pagerduty_integration ? 1 : 0
  name                = "critical-service-down"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_application_insights.main.id]

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 50
  }

  action {
    action_group_id = azurerm_monitor_action_group.pagerduty[0].id
  }

  description = "Critical: Service availability below 50% - Pages on-call engineer"
  severity    = 0
  frequency   = "PT1M"
  window_size = "PT5M"

  tags = var.tags
}

# OpsGenie webhook action (alternative to PagerDuty)
resource "azurerm_monitor_action_group" "opsgenie" {
  count               = var.enable_opsgenie_integration ? 1 : 0
  name                = "opsgenie-action-group"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "opsgenie"

  webhook_receiver {
    name        = "opsgenie-webhook"
    service_uri = var.opsgenie_webhook_url
    use_common_alert_schema = true
  }

  tags = var.tags
}
