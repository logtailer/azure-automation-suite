resource "azurerm_servicebus_namespace" "main" {
  count               = var.enable_service_bus ? 1 : 0
  name                = var.service_bus_namespace_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.service_bus_sku
  capacity            = var.service_bus_sku == "Premium" ? var.service_bus_capacity : 0
  minimum_tls_version = "1.2"
  tags                = local.common_tags
}

resource "azurerm_servicebus_queue" "platform_events" {
  count        = var.enable_service_bus ? 1 : 0
  name         = "platform-events"
  namespace_id = azurerm_servicebus_namespace.main[0].id

  max_delivery_count                   = 10
  dead_lettering_on_message_expiration = true
  lock_duration                        = "PT1M"
  default_message_ttl                  = "P14D"
  max_size_in_megabytes                = 1024
}

resource "azurerm_servicebus_queue" "dead_letter" {
  count        = var.enable_service_bus ? 1 : 0
  name         = "platform-events-dlq-reprocess"
  namespace_id = azurerm_servicebus_namespace.main[0].id

  max_delivery_count    = 3
  default_message_ttl   = "P7D"
  max_size_in_megabytes = 1024
}
