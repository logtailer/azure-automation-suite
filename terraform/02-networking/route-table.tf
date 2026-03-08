resource "azurerm_route_table" "private" {
  count               = var.enable_route_table ? 1 : 0
  name                = "rt-private"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  tags                = local.common_tags
}

resource "azurerm_route" "internet_via_firewall" {
  count               = var.enable_route_table ? 1 : 0
  name                = "route-internet-via-firewall"
  resource_group_name = data.azurerm_resource_group.foundation.name
  route_table_name    = azurerm_route_table.private[0].name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "private" {
  count          = var.enable_route_table ? 1 : 0
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private[0].id
}
