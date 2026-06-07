resource "azurerm_eventgrid_topic" "platform" {
  count               = var.enable_event_grid ? 1 : 0
  name                = "egt-platform-${var.environment}"
  resource_group_name = azurerm_resource_group.component.name
  location            = azurerm_resource_group.component.location
  input_schema        = "CloudEventSchemaV1_0"

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

resource "azurerm_eventgrid_event_subscription" "platform_servicebus" {
  count = var.enable_event_grid && var.enable_service_bus ? 1 : 0
  name  = "sub-platform-servicebus"
  scope = azurerm_eventgrid_topic.platform[0].id

  service_bus_queue_endpoint_id = azurerm_servicebus_queue.platform_events[0].id

  delivery_identity {
    type = "SystemAssigned"
  }

  retry_policy {
    max_delivery_attempts = 30
    event_time_to_live    = 1440
  }
}
