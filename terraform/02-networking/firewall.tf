resource "azurerm_subnet" "firewall" {
  count                = var.enable_firewall ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.firewall_subnet_address_prefix
}

resource "azurerm_public_ip" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  name                = "pip-firewall-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_firewall" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "afw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  tags                = local.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall[0].id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_firewall_policy" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "afwp-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  sku                 = var.firewall_sku_tier
  tags                = local.common_tags
}
