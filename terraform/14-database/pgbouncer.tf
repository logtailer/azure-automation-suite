resource "azurerm_container_group" "pgbouncer" {
  count               = var.enable_postgresql && var.enable_pgbouncer ? 1 : 0
  name                = "ci-pgbouncer-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_name
  os_type             = "Linux"
  ip_address_type     = "Private"
  subnet_ids          = [var.private_endpoint_subnet_id]
  tags                = var.tags

  container {
    name   = "pgbouncer"
    image  = "bitnami/pgbouncer:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 5432
      protocol = "TCP"
    }

    environment_variables = {
      PGBOUNCER_DATABASE        = "*"
      PGBOUNCER_POOL_MODE       = "transaction"
      PGBOUNCER_MAX_CLIENT_CONN = "200"
      PGBOUNCER_DEFAULT_POOL_SIZE = "20"
      POSTGRESQL_HOST           = azurerm_postgresql_flexible_server.main[0].fqdn
      POSTGRESQL_PORT           = "5432"
      POSTGRESQL_USERNAME       = var.postgresql_admin_login
    }

    secure_environment_variables = {
      POSTGRESQL_PASSWORD = var.postgresql_admin_password
    }
  }
}
