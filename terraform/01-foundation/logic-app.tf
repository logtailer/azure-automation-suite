resource "azurerm_logic_app_workflow" "alert_processor" {
  count               = var.enable_logic_app ? 1 : 0
  name                = "la-alert-processor-${var.component_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_logic_app_trigger_http_request" "alert_webhook" {
  count        = var.enable_logic_app ? 1 : 0
  name         = "alert-webhook"
  logic_app_id = azurerm_logic_app_workflow.alert_processor[0].id

  schema = jsonencode({
    type = "object"
    properties = {
      alertName     = { type = "string" }
      severity      = { type = "string" }
      resourceId    = { type = "string" }
      firedDateTime = { type = "string" }
    }
  })
}

resource "azurerm_logic_app_action_http" "notify_teams" {
  count        = var.enable_logic_app ? 1 : 0
  name         = "notify-teams"
  logic_app_id = azurerm_logic_app_workflow.alert_processor[0].id

  method = "POST"
  uri    = var.teams_webhook_url

  headers = {
    "Content-Type" = "application/json"
  }

  body = jsonencode({
    "@type"    = "MessageCard"
    "@context" = "http://schema.org/extensions"
    summary    = "Azure Alert"
    themeColor = "FF0000"
    title      = "@{triggerBody()?['alertName']}"
    text       = "Severity: @{triggerBody()?['severity']} | Resource: @{triggerBody()?['resourceId']}"
  })
}
