resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  count                      = var.log_analytics_workspace_id != "" ? 1 : 0
  name                       = "diag-kv-${var.environment}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "AuditEvent" }
  enabled_log { category = "AzurePolicyEvaluationDetails" }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
