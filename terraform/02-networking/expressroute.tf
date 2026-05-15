resource "azurerm_express_route_circuit" "main" {
  count               = var.enable_expressroute ? 1 : 0
  name                = "er-circuit-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location

  service_provider_name = var.er_service_provider
  peering_location      = var.er_peering_location
  bandwidth_in_mbps     = var.er_bandwidth_mbps

  sku {
    tier   = var.er_sku_tier
    family = var.er_sku_family
  }

  tags = var.tags
}

resource "azurerm_virtual_network_gateway" "er" {
  count               = var.enable_expressroute && var.enable_er_gateway ? 1 : 0
  name                = "ergw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  type                = "ExpressRoute"
  sku                 = var.er_gateway_sku

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.er_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway[0].id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "er_gateway" {
  count               = var.enable_expressroute && var.enable_er_gateway ? 1 : 0
  name                = "pip-ergw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "er" {
  count               = var.enable_expressroute && var.enable_er_gateway ? 1 : 0
  name                = "conn-er-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  type                = "ExpressRoute"

  virtual_network_gateway_id = azurerm_virtual_network_gateway.er[0].id
  express_route_circuit_id   = azurerm_express_route_circuit.main[0].id

  authorization_key = var.er_authorization_key

  tags = var.tags
}
