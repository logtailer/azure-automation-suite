output "postgresql_server_id" {
  description = "Resource ID of the PostgreSQL flexible server"
  value       = var.enable_postgresql ? azurerm_postgresql_flexible_server.main[0].id : null
}

output "postgresql_fqdn" {
  description = "FQDN of the PostgreSQL flexible server"
  value       = var.enable_postgresql ? azurerm_postgresql_flexible_server.main[0].fqdn : null
}

output "mysql_server_id" {
  description = "Resource ID of the MySQL flexible server"
  value       = var.enable_mysql ? azurerm_mysql_flexible_server.main[0].id : null
}

output "mysql_fqdn" {
  description = "FQDN of the MySQL flexible server"
  value       = var.enable_mysql ? azurerm_mysql_flexible_server.main[0].fqdn : null
}

output "redis_id" {
  description = "Resource ID of the Redis cache"
  value       = var.enable_redis ? azurerm_redis_cache.main[0].id : null
}

output "redis_hostname" {
  description = "Hostname of the Redis cache"
  value       = var.enable_redis ? azurerm_redis_cache.main[0].hostname : null
}

output "redis_primary_access_key" {
  description = "Primary access key for the Redis cache"
  value       = var.enable_redis ? azurerm_redis_cache.main[0].primary_access_key : null
  sensitive   = true
}
