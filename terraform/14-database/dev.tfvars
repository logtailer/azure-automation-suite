# Dev environment database configuration
resource_group_name = "rg-database-dev"
environment         = "dev"

enable_postgresql        = true
postgresql_server_name   = "psql-platform-dev-001"
postgresql_admin_login   = "psqladmin"
postgresql_sku_name      = "B_Standard_B1ms"
postgresql_storage_mb    = 32768
postgresql_version       = "15"
postgresql_backup_retention_days = 7
postgresql_geo_redundant_backup  = false

enable_mysql   = false
enable_redis   = true
redis_cache_name = "redis-platform-dev"
redis_capacity = 1
redis_family   = "C"
redis_sku_name = "Basic"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  CostCenter  = "engineering"
}
