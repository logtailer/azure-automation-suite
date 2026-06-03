resource "azurerm_app_configuration" "main" {
  count               = var.enable_app_config ? 1 : 0
  name                = var.app_config_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.app_config_sku

  local_auth_enabled         = false
  public_network_access      = var.app_config_public_access ? "Enabled" : "Disabled"
  purge_protection_enabled   = var.app_config_sku == "standard" ? true : false
  soft_delete_retention_days = var.app_config_sku == "standard" ? 7 : null

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "app_config_reader" {
  for_each             = var.enable_app_config ? var.app_config_reader_principal_ids : {}
  scope                = azurerm_app_configuration.main[0].id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = each.value
}

resource "azurerm_private_endpoint" "app_config" {
  count               = var.enable_app_config && var.app_config_private_endpoint_subnet_id != "" ? 1 : 0
  name                = "pe-appconfig-${var.component_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.app_config_private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-appconfig"
    private_connection_resource_id = azurerm_app_configuration.main[0].id
    subresource_names              = ["configurationStores"]
    is_manual_connection           = false
  }

  tags = var.tags
}
