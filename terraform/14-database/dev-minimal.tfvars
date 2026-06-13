resource_group_name = "database-dev-rg"
environment         = "dev"

# PostgreSQL — Burstable B1ms is the cheapest Flexible Server SKU (~$12/month)
enable_postgresql                = true
postgresql_server_name           = "psql-dev-platform"
postgresql_admin_login           = "pgadmin"
postgresql_admin_password        = "REPLACE_ME_strong_password_123!"
postgresql_sku_name              = "B_Standard_B1ms"
postgresql_storage_mb            = 32768
postgresql_version               = "15"
postgresql_backup_retention_days = 35
postgresql_geo_redundant_backup  = false
postgresql_allowed_ip_ranges     = []

# Disable MySQL and Redis (save ~$20-30/month)
enable_mysql = false
enable_redis = false

# Disable private endpoint (needs VNet integration, adds complexity for dev)
enable_private_endpoint = false

# Disable read replica (doubles DB cost)
enable_read_replica = false
enable_pgbouncer    = false

allow_azure_services = true

# Alerts
enable_db_alerts           = false
enable_database            = true
db_backup_retention_days   = 35
db_backup_storage_alert_gb = 50

log_analytics_workspace_id = ""

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
