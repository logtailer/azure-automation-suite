resource "azurerm_network_ddos_protection_plan" "main" {
  count               = var.enable_ddos_protection ? 1 : 0
  name                = "ddos-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  tags                = local.common_tags
}

resource "azurerm_virtual_network" "hub" {
  count               = var.enable_hub_spoke ? 1 : 0
  name                = "vnet-hub-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  address_space       = var.hub_vnet_address_space
  tags                = local.common_tags

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.main[0].id
      enable = true
    }
  }
}
