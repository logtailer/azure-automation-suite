# Cost Analytics and Reporting for Azure Platform

# Create Azure Monitor Action Group for cost notifications
resource "azurerm_monitor_action_group" "cost_alerts" {
  name                = "cost-alerts-${var.tags.Environment}"
  resource_group_name = azurerm_resource_group.tfstate.name
  short_name          = "cost-alert"

  dynamic "email_receiver" {
    for_each = var.cost_alert_emails
    content {
      name          = "email-${index(var.cost_alert_emails, email_receiver.value)}"
      email_address = email_receiver.value
    }
  }

  tags = var.tags
}

# Create Log Analytics Workspace for cost analytics
resource "azurerm_log_analytics_workspace" "cost_analytics" {
  name                = "cost-analytics-${var.tags.Environment}"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(var.tags, {
    Purpose = "CostAnalytics"
  })
}

# Create KQL queries for cost analysis
resource "azurerm_log_analytics_saved_search" "component_costs" {
  name                       = "ComponentCosts"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cost_analytics.id
  category                   = "Cost Management"
  display_name              = "Cost by Component"
  query = <<-EOT
    AzureActivity
    | where TimeGenerated >= ago(30d)
    | where ResourceGroup has "${var.tags.Project}"
    | extend Component = case(
        ResourceGroup contains "foundation", "Foundation",
        ResourceGroup contains "networking", "Networking", 
        ResourceGroup contains "aks", "AKS",
        ResourceGroup contains "security", "Security",
        ResourceGroup contains "cicd", "CI/CD",
        ResourceGroup contains "observability", "Observability",
        ResourceGroup contains "idp", "IDP",
        "Other"
    )
    | summarize Operations = count() by Component, bin(TimeGenerated, 1d)
    | render timechart
  EOT

  tags = var.tags
}

# Create budget alerts for each component type
resource "azurerm_consumption_budget_resource_group" "component_budgets" {
  for_each = var.component_budgets
  
  name              = "${each.key}-budget-${var.tags.Environment}"
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.tags.Project}-${each.key}-${var.tags.Environment}-rg"
  
  amount     = each.value.amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01", timestamp())
    end_date   = formatdate("YYYY-MM-01", timeadd(timestamp(), "8760h"))
  }

  notification {
    enabled   = true
    threshold = each.value.threshold
    operator  = "GreaterThan"
    contact_emails = var.cost_alert_emails
  }

  depends_on = [azurerm_resource_group.component]
}
