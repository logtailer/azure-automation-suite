resource "azurerm_consumption_budget_subscription" "platform" {
  count           = var.enable_cost_budget ? 1 : 0
  name            = "budget-platform-${var.environment}"
  subscription_id = data.azurerm_subscription.current.id
  amount          = var.monthly_budget_amount
  time_grain      = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = values(var.critical_alert_emails)
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = values(var.critical_alert_emails)
  }

  notification {
    enabled        = true
    threshold      = 110
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = values(var.critical_alert_emails)
  }
}
