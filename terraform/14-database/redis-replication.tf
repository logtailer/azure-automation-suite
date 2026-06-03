resource "azurerm_redis_cache" "replica" {
  count               = var.enable_redis && var.enable_redis_replica ? 1 : 0
  name                = "${var.redis_cache_name}-replica"
  resource_group_name = var.resource_group_name
  location            = var.redis_replica_location
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name

  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = var.tags
}

resource "azurerm_redis_linked_server" "geo_replica" {
  count                       = var.enable_redis && var.enable_redis_replica ? 1 : 0
  target_redis_cache_name     = var.redis_cache_name
  resource_group_name         = var.resource_group_name
  linked_redis_cache_id       = azurerm_redis_cache.replica[0].id
  linked_redis_cache_location = var.redis_replica_location
  server_role                 = "Secondary"
}
