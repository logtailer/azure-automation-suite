# Cost Management Resources for Azure Platform
# These budgets are created once and track all components

# Create a comprehensive budget for the entire platform
resource "azurerm_consumption_budget_subscription" "platform_budget" {
  name            = "azure-platform-${var.tags.Environment}-budget"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01", timestamp())
    end_date   = formatdate("YYYY-MM-01", timeadd(timestamp(), "8760h")) # 1 year from now
  }

  notification {
    enabled   = true
    threshold = var.cost_alert_threshold_1
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }

  notification {
    enabled   = true
    threshold = var.cost_alert_threshold_2
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }

  notification {
    enabled   = true
    threshold = var.cost_alert_threshold_3
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }
}

# Component-specific budget (lighter tracking per resource group)
resource "azurerm_consumption_budget_resource_group" "component_budget" {
  count             = var.enable_component_budget ? 1 : 0
  name              = "${var.resource_group_name}-budget"
  resource_group_id = azurerm_resource_group.component.id

  amount     = var.component_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01", timestamp())
    end_date   = formatdate("YYYY-MM-01", timeadd(timestamp(), "8760h"))
  }

  notification {
    enabled   = true
    threshold = 80 # Alert at 80% of component budget
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }
}

# Cost anomaly detection (only for the platform, not per component)
resource "azurerm_consumption_budget_subscription" "anomaly_detection" {
  count           = var.component_name == "foundation" ? 1 : 0  # Only create for foundation
  name            = "anomaly-detection-${var.tags.Environment}"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  amount     = var.monthly_budget_amount * 1.5 # 150% of normal budget
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01", timestamp())
    end_date   = formatdate("YYYY-MM-01", timeadd(timestamp(), "8760h"))
  }

  notification {
    enabled   = true
    threshold = 100 # 100% of anomaly budget
    operator  = "GreaterThan"

    contact_emails = var.cost_alert_emails
  }
}

# Data source to get current subscription
data "azurerm_client_config" "current" {}
