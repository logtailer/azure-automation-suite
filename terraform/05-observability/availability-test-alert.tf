resource "azurerm_monitor_metric_alert" "availability_drop" {
  count               = var.enable_app_insights && var.enable_synthetic_monitor ? 1 : 0
  name                = "alert-availability-drop-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_application_insights.platform[0].id]
  description         = "Alert when platform API availability falls below 99% across synthetic monitor locations"
  severity            = 1
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
  }
}
