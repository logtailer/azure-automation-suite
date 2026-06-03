resource "azurerm_subnet" "gateway" {
  count                = var.enable_vpn_gateway ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.foundation.name
  virtual_network_name = var.enable_hub_spoke ? azurerm_virtual_network.hub[0].name : azurerm_virtual_network.main.name
  address_prefixes     = var.gateway_subnet_address_prefix
}

resource "azurerm_public_ip" "vpn_gateway" {
  count               = var.enable_vpn_gateway ? 1 : 0
  name                = "pip-vpn-gateway"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_virtual_network_gateway" "main" {
  count               = var.enable_vpn_gateway ? 1 : 0
  name                = "vpn-gateway"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.vpn_gateway_sku
  active_active       = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway[0].id
  }

  tags = local.common_tags
}
