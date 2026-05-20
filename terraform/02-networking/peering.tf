resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count                     = var.enable_hub_spoke ? 1 : 0
  name                      = "peer-hub-to-${var.vnet_name}"
  resource_group_name       = var.foundation_resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub[0].name
  remote_virtual_network_id = azurerm_virtual_network.main.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.enable_vpn_gateway || var.enable_er_gateway
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count                     = var.enable_hub_spoke ? 1 : 0
  name                      = "peer-${var.vnet_name}-to-hub"
  resource_group_name       = var.foundation_resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = azurerm_virtual_network.hub[0].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.enable_vpn_gateway || var.enable_er_gateway
}

resource "azurerm_virtual_network_peering" "additional" {
  for_each                  = var.additional_vnet_peerings
  name                      = "peer-${var.vnet_name}-to-${each.key}"
  resource_group_name       = var.foundation_resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = each.value

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
