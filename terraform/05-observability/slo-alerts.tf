resource "azurerm_monitor_scheduled_query_rules_alert_v2" "error_budget_burn" {
  count                = var.enable_slo_alerts ? 1 : 0
  name                 = "slo-error-budget-burn-fast"
  resource_group_name  = var.resource_group_name
  location             = var.location
  description          = "Error budget burning faster than 14x the allowed rate (1h window)"
  severity             = 1
  enabled              = true
  evaluation_frequency = "PT10M"
  window_duration      = "PT1H"

  scopes = [var.log_analytics_workspace_id]

  criteria {
    query = <<-KQL
      requests
      | where success == false
      | summarize
          total    = count(),
          failures = countif(success == false)
          by bin(timestamp, 1m)
      | extend error_rate = todouble(failures) / todouble(total)
      | where error_rate > ${var.slo_error_rate_threshold}
    KQL

    time_aggregation_method = "Count"
    threshold               = 5
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 3
      number_of_evaluation_periods             = 6
    }
  }

  action {
    action_groups = [var.critical_action_group_id]
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "p99_latency" {
  count                = var.enable_slo_alerts ? 1 : 0
  name                 = "slo-p99-latency-breach"
  resource_group_name  = var.resource_group_name
  location             = var.location
  description          = "p99 request latency exceeds SLO target"
  severity             = 2
  enabled              = true
  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"

  scopes = [var.log_analytics_workspace_id]

  criteria {
    query = <<-KQL
      requests
      | summarize p99 = percentile(duration, 99) by bin(timestamp, 5m)
      | where p99 > ${var.slo_latency_p99_ms}
    KQL

    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 2
      number_of_evaluation_periods             = 3
    }
  }

  action {
    action_groups = [var.warning_action_group_id]
  }

  tags = var.tags
}
