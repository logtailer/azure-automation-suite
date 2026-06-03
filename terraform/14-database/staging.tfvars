# Staging environment database configuration
resource_group_name = "rg-database-staging"
environment         = "staging"

enable_postgresql                = true
postgresql_server_name           = "psql-platform-staging-001"
postgresql_admin_login           = "psqladmin"
postgresql_sku_name              = "GP_Standard_D2s_v3"
postgresql_storage_mb            = 65536
postgresql_version               = "15"
postgresql_backup_retention_days = 14
postgresql_geo_redundant_backup  = false

enable_mysql     = false
enable_redis     = true
redis_cache_name = "redis-platform-staging"
redis_capacity   = 1
redis_family     = "C"
redis_sku_name   = "Standard"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  CostCenter  = "engineering"
}
