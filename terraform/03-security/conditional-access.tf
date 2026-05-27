resource "azurerm_role_assignment" "break_glass_owner" {
  count                = var.enable_break_glass ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = var.break_glass_principal_id
  description          = "Break-glass emergency account — MFA-exempt, monitored separately"
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "break_glass_signin" {
  count               = var.enable_break_glass && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-break-glass-signin"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Alert immediately when the break-glass account signs in"
  severity            = 0
  enabled             = true
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  scopes = [var.log_analytics_workspace_id]

  criteria {
    query = <<-KQL
      SigninLogs
      | where UserPrincipalName has "${var.break_glass_upn_fragment}"
        and ResultType == "0"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "mfa_disabled_user" {
  count               = var.enable_mfa_alerts && var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "alert-mfa-disabled-account"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Alert when MFA is disabled for a user account via audit log"
  severity            = 1
  enabled             = true
  evaluation_frequency = "PT10M"
  window_duration      = "PT10M"

  scopes = [var.log_analytics_workspace_id]

  criteria {
    query = <<-KQL
      AuditLogs
      | where OperationName == "Disable Strong Authentication"
        or (OperationName == "Update user" and TargetResources[0].modifiedProperties has "StrongAuthenticationRequirement")
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
