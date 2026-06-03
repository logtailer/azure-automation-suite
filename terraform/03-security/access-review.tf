resource "azurerm_role_assignment" "privileged_group_owner" {
  count                = var.enable_pim_group ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = var.pim_group_object_id
  description          = "Privileged access group — managed via PIM, reviewed quarterly"
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "privileged_role_assignment" {
  count                = var.enable_pim_alerts ? 1 : 0
  name                 = "alert-new-owner-assignment"
  resource_group_name  = var.resource_group_name
  location             = var.location
  description          = "Alert when Owner or User Access Administrator is granted"
  severity             = 1
  enabled              = true
  evaluation_frequency = "PT10M"
  window_duration      = "PT10M"

  scopes = [var.log_analytics_workspace_id]

  criteria {
    query = <<-KQL
      AzureActivity
      | where OperationNameValue has_any ("Microsoft.Authorization/roleAssignments/write")
        and ActivityStatusValue == "Success"
        and Properties has_any ("Owner", "User Access Administrator")
    KQL

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.critical_action_group_id]
  }

  tags = var.tags
}
