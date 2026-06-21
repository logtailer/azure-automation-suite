resource "azurerm_api_management" "main" {
  count               = var.enable_apim ? 1 : 0
  name                = var.apim_name
  resource_group_name = var.resource_group_name
  location            = var.location
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = "${var.apim_sku}_${var.apim_capacity}"

  identity {
    type = "SystemAssigned"
  }

  virtual_network_type = var.apim_vnet_type

  dynamic "virtual_network_configuration" {
    for_each = var.apim_vnet_type != "None" ? toset(["enabled"]) : toset([])
    content {
      subnet_id = var.apim_subnet_id
    }
  }

  tags = var.tags
}

resource "azurerm_api_management_logger" "main" {
  count               = var.enable_apim && var.app_insights_instrumentation_key != "" ? 1 : 0
  name                = "apim-logger"
  api_management_name = azurerm_api_management.main[0].name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = var.app_insights_instrumentation_key
  }
}

resource "azurerm_api_management_named_value" "env" {
  count               = var.enable_apim ? 1 : 0
  name                = "environment"
  api_management_name = azurerm_api_management.main[0].name
  resource_group_name = var.resource_group_name
  display_name        = "environment"
  value               = var.tags["environment"]
}
