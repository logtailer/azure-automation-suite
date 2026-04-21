resource "azurerm_subnet" "appgw" {
  count                = var.enable_application_gateway ? 1 : 0
  name                 = "snet-appgw-${var.vnet_name}"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.appgw_subnet_address_prefix
}

resource "azurerm_public_ip" "appgw" {
  count               = var.enable_application_gateway ? 1 : 0
  name                = "pip-appgw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

resource "azurerm_application_gateway" "main" {
  count               = var.enable_application_gateway ? 1 : 0
  name                = "agw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  zones               = ["1", "2", "3"]
  tags                = local.common_tags

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw[0].id
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw[0].id
  }

  frontend_port {
    name = "port-80"
    port = 80
  }

  frontend_port {
    name = "port-443"
    port = 443
  }

  backend_address_pool {
    name = "aks-backend-pool"
  }

  backend_http_settings {
    name                  = "aks-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "aks-http-settings"
    priority                   = 100
  }
}
