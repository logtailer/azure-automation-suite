resource "azurerm_subnet" "postgres_delegated" {
  count                = var.enable_postgres_subnet_delegation ? 1 : 0
  name                 = "snet-postgres-delegated"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.postgres_subnet_address_prefix

  delegation {
    name = "postgres-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "aci_delegated" {
  count                = var.enable_aci_subnet ? 1 : 0
  name                 = "snet-aci-delegated"
  resource_group_name  = var.foundation_resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aci_subnet_address_prefix

  delegation {
    name = "aci-delegation"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}
