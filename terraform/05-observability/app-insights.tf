resource "azurerm_application_insights" "platform" {
  count               = var.enable_app_insights ? 1 : 0
  name                = "appi-platform-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  retention_in_days   = var.app_insights_retention_days
  sampling_percentage = var.app_insights_sampling_percentage
  tags                = var.tags
}

resource "azurerm_application_insights_smart_detection_rule" "slow_requests" {
  count                   = var.enable_app_insights ? 1 : 0
  name                    = "Slow server response time"
  application_insights_id = azurerm_application_insights.platform[0].id
  enabled                 = true
}

resource "azurerm_application_insights_smart_detection_rule" "slow_server_response" {
  count                   = var.enable_app_insights ? 1 : 0
  name                    = "Slow server response time"
  application_insights_id = azurerm_application_insights.platform[0].id
  enabled                 = true
}
