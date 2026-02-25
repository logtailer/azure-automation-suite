resource "azurerm_virtual_network" "hub" {
  count               = var.enable_hub_spoke ? 1 : 0
  name                = "${var.vnet_name}-hub"
  address_space       = var.hub_vnet_address_space
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  tags                = local.common_tags
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count                        = var.enable_hub_spoke ? 1 : 0
  name                         = "peer-hub-to-spoke"
  resource_group_name          = data.azurerm_resource_group.foundation.name
  virtual_network_name         = azurerm_virtual_network.hub[0].name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count                        = var.enable_hub_spoke ? 1 : 0
  name                         = "peer-spoke-to-hub"
  resource_group_name          = data.azurerm_resource_group.foundation.name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = azurerm_virtual_network.hub[0].id
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_virtual_network_access = true
}
