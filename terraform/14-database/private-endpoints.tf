resource "azurerm_private_endpoint" "postgresql" {
  count               = var.enable_postgresql && var.enable_private_endpoint ? 1 : 0
  name                = "pe-${var.postgresql_server_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-postgresql"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main[0].id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  tags = local.common_tags
}

resource "azurerm_private_endpoint" "redis" {
  count               = var.enable_redis && var.enable_private_endpoint ? 1 : 0
  name                = "pe-${var.redis_cache_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-redis"
    private_connection_resource_id = azurerm_redis_cache.main[0].id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  tags = local.common_tags
}
