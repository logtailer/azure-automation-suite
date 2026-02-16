# Production environment database configuration
resource_group_name = "rg-database-prod"
environment         = "prod"

enable_postgresql        = true
postgresql_server_name   = "psql-platform-prod-001"
postgresql_admin_login   = "psqladmin"
postgresql_sku_name      = "GP_Standard_D4s_v3"
postgresql_storage_mb    = 131072
postgresql_version       = "15"
postgresql_backup_retention_days = 35
postgresql_geo_redundant_backup  = true

enable_mysql   = false
enable_redis   = true
redis_cache_name = "redis-platform-prod"
redis_capacity = 2
redis_family   = "C"
redis_sku_name = "Standard"

tags = {
  Environment    = "production"
  Project        = "azure-platform"
  CostCenter     = "engineering"
  Compliance     = "required"
  DataClassification = "confidential"
}
