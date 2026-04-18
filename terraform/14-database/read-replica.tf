resource "azurerm_postgresql_flexible_server" "read_replica" {
  count               = var.enable_postgresql && var.enable_read_replica ? 1 : 0
  name                = "${var.postgresql_server_name}-replica"
  resource_group_name = var.resource_group_name
  location            = var.replica_location
  version             = var.postgresql_version
  sku_name            = var.replica_sku_name

  create_mode               = "Replica"
  source_server_id          = azurerm_postgresql_flexible_server.main[0].id
  geo_redundant_backup_enabled = false

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = var.tags
}
