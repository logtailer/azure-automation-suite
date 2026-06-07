resource "azurerm_monitor_metric_alert" "vnet_dropped_packets" {
  count               = var.enable_network_alerts ? 1 : 0
  name                = "alert-vnet-dropped-packets-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.vnet_resource_id]
  description         = "Alert when VNet dropped packet rate exceeds threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/virtualNetworks"
    metric_name      = "DroppedPackets"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000
  }

  action {
    action_group_id = azurerm_monitor_action_group.warning.id
  }
}

resource "azurerm_monitor_metric_alert" "appgw_unhealthy_hosts" {
  count               = var.enable_network_alerts && var.appgw_resource_id != "" ? 1 : 0
  name                = "alert-appgw-unhealthy-hosts-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [var.appgw_resource_id]
  description         = "Alert when Application Gateway backend pool has unhealthy hosts"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
  }
}
