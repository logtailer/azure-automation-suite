terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "foundation" {
  name = var.foundation_resource_group_name
}

# Action Group for budget alerts
resource "azurerm_monitor_action_group" "budget_alerts" {
  name                = "budget-alerts-action-group"
  resource_group_name = data.azurerm_resource_group.foundation.name
  short_name          = "budgetalrt"

  email_receiver {
    name          = "budget-admin"
    email_address = var.alert_email
  }

  tags = var.tags
}

# Subscription Budget
resource "azurerm_consumption_budget_subscription" "monthly" {
  name            = "monthly-budget"
  subscription_id = data.azurerm_subscription.current.id

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  notification {
    enabled   = true
    threshold = 80.0
    operator  = "GreaterThan"

    contact_emails = [var.alert_email]
  }

  notification {
    enabled   = true
    threshold = 100.0
    operator  = "GreaterThan"

    contact_emails = [var.alert_email]
  }
}

# Resource Group Budget
resource "azurerm_consumption_budget_resource_group" "foundation" {
  name              = "foundation-rg-budget"
  resource_group_id = data.azurerm_resource_group.foundation.id

  amount     = var.rg_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "GreaterThan"

    contact_emails = [var.alert_email]
  }
}
