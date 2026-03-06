resource "azurerm_key_vault_secret" "postgresql_connection_string" {
  count        = var.enable_postgresql && var.key_vault_id != "" ? 1 : 0
  name         = "postgresql-connection-string"
  key_vault_id = var.key_vault_id
  value = format(
    "postgresql://%s:%s@%s:5432/postgres?sslmode=require",
    var.postgresql_admin_login,
    var.postgresql_admin_password,
    azurerm_postgresql_flexible_server.main[0].fqdn
  )

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  count        = var.enable_redis && var.key_vault_id != "" ? 1 : 0
  name         = "redis-connection-string"
  key_vault_id = var.key_vault_id
  value = format(
    "rediss://:%s@%s:6380",
    azurerm_redis_cache.main[0].primary_access_key,
    azurerm_redis_cache.main[0].hostname
  )

  tags = local.common_tags
}
