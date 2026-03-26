resource "azurerm_private_dns_zone" "aks" {
  count               = var.enable_private_dns ? 1 : 0
  name                = var.aks_private_dns_zone_name
  resource_group_name = var.foundation_resource_group_name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  count                 = var.enable_private_dns ? 1 : 0
  name                  = "link-aks-dns-${var.vnet_name}"
  resource_group_name   = var.foundation_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks[0].name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.common_tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  count               = var.enable_private_dns ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.foundation_resource_group_name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count                 = var.enable_private_dns ? 1 : 0
  name                  = "link-kv-dns-${var.vnet_name}"
  resource_group_name   = var.foundation_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.common_tags
}
