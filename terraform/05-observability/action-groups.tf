resource "azurerm_monitor_action_group" "critical" {
  name                = "ag-critical-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "critical"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.critical_alert_emails
    content {
      name                    = "email-${email_receiver.key}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.pagerduty_webhook_url != "" ? [1] : []
    content {
      name                    = "pagerduty"
      service_uri             = var.pagerduty_webhook_url
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_action_group" "warning" {
  name                = "ag-warning-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "warning"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.warning_alert_emails
    content {
      name                    = "email-${email_receiver.key}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}
