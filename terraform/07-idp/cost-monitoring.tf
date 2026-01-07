# Cost Management for IDP Component
# Lightweight budget tracking for the IDP resource group

# Component-specific budget for IDP resource group
resource "azurerm_consumption_budget_resource_group" "idp_budget" {
  count             = var.enable_component_budget ? 1 : 0
  name              = "${var.resource_group_name}-budget"
  resource_group_id = data.azurerm_resource_group.main.id

  amount     = var.component_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01", timestamp())
    end_date   = formatdate("YYYY-MM-01", timeadd(timestamp(), "8760h"))
  }

  notification {
    enabled   = true
    threshold = var.cost_alert_threshold
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }
}
