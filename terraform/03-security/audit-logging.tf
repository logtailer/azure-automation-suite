# Audit Logging and Monitoring
# Enterprise audit trails and security monitoring

# Data source for Log Analytics workspace (from observability module)
data "terraform_remote_state" "observability" {
  count   = var.enable_audit_logging && var.log_analytics_workspace_id != "" ? 0 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "observability"
    key                  = "observability.tfstate"
  }
}

# Diagnostic settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  count                      = var.enable_audit_logging ? 1 : 0
  name                       = "diag-keyvault-${var.environment}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Alert for Key Vault access anomalies
resource "azurerm_monitor_metric_alert" "keyvault_availability" {
  count               = var.enable_kv_alerts ? 1 : 0
  name                = "alert-keyvault-availability-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_key_vault.main.id]

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99
  }

  action {
    action_group_id = var.action_group_id
  }

  description = "Alert when Key Vault availability drops below 99%"
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for Key Vault capacity
resource "azurerm_monitor_metric_alert" "keyvault_saturation" {
  count               = var.enable_kv_alerts ? 1 : 0
  name                = "alert-keyvault-saturation-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_key_vault.main.id]

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "SaturationShoebox"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 75
  }

  action {
    action_group_id = var.action_group_id
  }

  description = "Alert when Key Vault capacity exceeds 75%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for failed Key Vault operations
resource "azurerm_monitor_metric_alert" "keyvault_failed_requests" {
  count               = var.enable_kv_alerts ? 1 : 0
  name                = "alert-keyvault-failed-requests-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_key_vault.main.id]

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = var.action_group_id
  }

  description = "Alert when Key Vault has more than 10 failed requests"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}
