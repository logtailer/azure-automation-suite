resource "azurerm_monitor_data_collection_endpoint" "otel" {
  count               = var.enable_otel_collector ? 1 : 0
  name                = "dce-otel-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  kind                = "Linux"
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_rule" "otel" {
  count                       = var.enable_otel_collector ? 1 : 0
  name                        = "dcr-otel-${var.environment}"
  resource_group_name         = data.azurerm_resource_group.main.name
  location                    = data.azurerm_resource_group.main.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.otel[0].id
  tags                        = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "otel-logs"
    }
  }

  data_flow {
    streams      = ["Microsoft-CommonSecurityLog"]
    destinations = ["otel-logs"]
  }
}
