resource "azurerm_private_dns_resolver" "main" {
  count               = var.enable_dns_resolver ? 1 : 0
  name                = "dnsresolver-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  count                   = var.enable_dns_resolver ? 1 : 0
  name                    = "inbound-${var.vnet_name}"
  private_dns_resolver_id = azurerm_private_dns_resolver.main[0].id
  location                = var.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_resolver_inbound[0].id
  }

  tags = var.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "main" {
  count                   = var.enable_dns_resolver ? 1 : 0
  name                    = "outbound-${var.vnet_name}"
  private_dns_resolver_id = azurerm_private_dns_resolver.main[0].id
  location                = var.location
  subnet_id               = azurerm_subnet.dns_resolver_outbound[0].id

  tags = var.tags
}

resource "azurerm_subnet" "dns_resolver_inbound" {
  count                = var.enable_dns_resolver ? 1 : 0
  name                 = "snet-dns-inbound"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.dns_resolver_inbound_subnet_prefix

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "dns_resolver_outbound" {
  count                = var.enable_dns_resolver ? 1 : 0
  name                 = "snet-dns-outbound"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.dns_resolver_outbound_subnet_prefix

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
