resource "azurerm_monitor_diagnostic_setting" "nsg_public" {
  name                       = "diag-nsg-public"
  target_resource_id         = azurerm_network_security_group.public.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}
