# Component-level budget for Artifactory
resource "azurerm_consumption_budget_resource_group" "artifactory_budget" {
  count             = var.enable_component_budget ? 1 : 0
  name              = "${var.resource_group_name}-artifactory-budget"
  resource_group_id = data.azurerm_resource_group.main.id

  amount     = var.component_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
    end_date   = formatdate("YYYY-MM-01'T'00:00:00'Z'", timeadd(timestamp(), "8760h"))
  }

  notification {
    enabled   = true
    threshold = var.cost_alert_threshold
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }
}
