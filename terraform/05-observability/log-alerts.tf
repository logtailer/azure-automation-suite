resource "azurerm_monitor_scheduled_query_rules_alert_v2" "high_error_rate" {
  count                = var.log_analytics_workspace_id != "" ? 1 : 0
  name                 = "alert-high-error-rate-${var.environment}"
  resource_group_name  = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  severity             = 1
  enabled              = true
  description          = "Alert when application error rate exceeds 5% over 5 minutes"
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_log_analytics_workspace.main.id]
  tags                 = var.tags

  criteria {
    query                   = <<-QUERY
      ContainerLog
      | where LogEntry has_any ("ERROR", "FATAL", "CRITICAL")
      | where ContainerName contains "platform"
      | summarize ErrorCount=count() by bin(TimeGenerated, 5m)
      | where ErrorCount > 50
    QUERY
    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled = true
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "kv_unauthorized_access" {
  count                = var.log_analytics_workspace_id != "" ? 1 : 0
  name                 = "alert-kv-unauthorized-${var.environment}"
  resource_group_name  = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  severity             = 2
  enabled              = true
  description          = "Alert on repeated unauthorized access attempts to Key Vault"
  evaluation_frequency = "PT15M"
  window_duration      = "PT15M"
  scopes               = [azurerm_log_analytics_workspace.main.id]
  tags                 = var.tags

  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where ResultType == "Unauthorized" or ResultType == "Forbidden"
      | summarize Count=count() by CallerIPAddress, bin(TimeGenerated, 15m)
      | where Count > 10
    QUERY
    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }
}
