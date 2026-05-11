variable "resource_group_name" {
  description = "Resource group for database resources"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# PostgreSQL
variable "enable_postgresql" {
  type    = bool
  default = false
}
variable "postgresql_server_name" {
  type    = string
  default = ""
}
variable "postgresql_admin_login" {
  type    = string
  default = "psqladmin"
}
variable "postgresql_admin_password" {
  type      = string
  default   = ""
  sensitive = true
}
variable "postgresql_sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}
variable "postgresql_storage_mb" {
  type    = number
  default = 32768
}
variable "postgresql_version" {
  type    = string
  default = "15"
}
variable "postgresql_backup_retention_days" {
  type    = number
  default = 7
}
variable "postgresql_geo_redundant_backup" {
  type    = bool
  default = false
}

# MySQL
variable "enable_mysql" {
  type    = bool
  default = false
}
variable "mysql_server_name" {
  type    = string
  default = ""
}
variable "mysql_admin_login" {
  type    = string
  default = "mysqladmin"
}
variable "mysql_admin_password" {
  type      = string
  default   = ""
  sensitive = true
}
variable "mysql_sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}
variable "mysql_version" {
  type    = string
  default = "8.0.21"
}
variable "mysql_backup_retention_days" {
  type    = number
  default = 7
}
variable "mysql_geo_redundant_backup" {
  type    = bool
  default = false
}

# Redis
variable "enable_redis" {
  type    = bool
  default = false
}
variable "redis_cache_name" {
  type    = string
  default = ""
}
variable "redis_capacity" {
  type    = number
  default = 1
}
variable "redis_family" {
  type    = string
  default = "C"
}
variable "redis_sku_name" {
  type    = string
  default = "Standard"
}

variable "enable_private_endpoint" {
  description = "Enable private endpoints for database resources"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint placement"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostic settings"
  type        = string
  default     = ""
}

variable "allow_azure_services" {
  description = "Allow Azure services to access the PostgreSQL server"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "Key Vault resource ID to store database connection strings as secrets"
  type        = string
  default     = ""
}

variable "postgresql_allowed_ip_ranges" {
  description = "Map of named IP ranges allowed to access PostgreSQL (name -> {start, end})"
  type = map(object({
    start = string
    end   = string
  }))
  default = {}
}

variable "enable_read_replica" {
  description = "Create a read replica of the PostgreSQL flexible server in a secondary region"
  type        = bool
  default     = false
}

variable "replica_location" {
  description = "Azure region for the PostgreSQL read replica"
  type        = string
  default     = "westus"
}

variable "replica_sku_name" {
  description = "SKU for the read replica (can be smaller than primary)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "enable_pgbouncer" {
  description = "Deploy a PgBouncer connection pooler container alongside PostgreSQL"
  type        = bool
  default     = false
}

variable "postgres_max_connections_alert_threshold" {
  description = "Active connection count threshold for PostgreSQL high-connections alert"
  type        = number
  default     = 80
}
