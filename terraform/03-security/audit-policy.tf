resource "azurerm_monitor_diagnostic_setting" "key_vault_audit" {
  count                      = var.enable_audit_logging ? 1 : 0
  name                       = "diag-kv-audit"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }
}
