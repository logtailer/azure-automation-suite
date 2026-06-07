resource "azurerm_container_registry" "main" {
  count                         = var.enable_acr ? 1 : 0
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.component.name
  location                      = azurerm_resource_group.component.location
  sku                           = var.acr_sku
  admin_enabled                 = false
  zone_redundancy_enabled       = var.acr_sku == "Premium"
  anonymous_pull_enabled        = false
  export_policy_enabled         = true
  public_network_access_enabled = !var.acr_private_only
  tags                          = local.common_tags

  retention_policy_in_days = var.acr_retention_days

  dynamic "georeplications" {
    for_each = var.acr_geo_replications
    content {
      location                  = georeplications.value
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = true
    }
  }
}
