variable "resource_group_name" {
  description = "Name of the resource group for this component"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "tfstate_resource_group" {
  description = "Resource group containing Terraform state"
  type        = string
}

variable "tfstate_storage_account" {
  description = "Storage account containing Terraform state"
  type        = string
}

variable "postgresql_server_name" {
  description = "Name of the PostgreSQL server for Backstage"
  type        = string
}

variable "postgresql_storage_mb" {
  description = "Storage size in MB for PostgreSQL server"
  type        = number
  default     = 32768
}

variable "postgresql_sku_name" {
  description = "SKU name for PostgreSQL server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgresql_backup_retention_days" {
  description = "Backup retention days for PostgreSQL"
  type        = number
  default     = 7
}

variable "postgresql_geo_redundant_backup" {
  description = "Enable geo-redundant backup for PostgreSQL"
  type        = bool
  default     = false
}

variable "db_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "backstage_admin"
}

variable "db_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub personal access token for Backstage"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "GitHub organization for Backstage integration"
  type        = string
}

variable "github_client_id" {
  description = "GitHub OAuth app client ID"
  type        = string
}

variable "github_client_secret" {
  description = "GitHub OAuth app client secret"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "application_name" {
  description = "Display name for the Azure AD application"
  type        = string
  default     = "Platform Application"
}

variable "homepage_url" {
  description = "Homepage URL for the application"
  type        = string
  default     = "https://platform.example.com"
}

variable "redirect_uris" {
  description = "List of redirect URIs for the application"
  type        = list(string)
  default     = ["https://platform.example.com/auth/callback"]
}

variable "admin_group_name" {
  description = "Name of the admin group"
  type        = string
  default     = "Platform Admins"
}

variable "developer_group_name" {
  description = "Name of the developer group"
  type        = string
  default     = "Platform Developers"
}

variable "viewer_group_name" {
  description = "Name of the viewer group"
  type        = string
  default     = "Platform Viewers"
}

variable "container_cpu" {
  description = "CPU cores for the Backstage container"
  type        = string
  default     = "1.0"
}

variable "container_memory" {
  description = "Memory in GB for the Backstage container"
  type        = string
  default     = "2.0"
}

variable "client_secret_end_date" {
  description = "End date for Azure AD client secret (format: YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = "2027-12-31T23:59:59Z"
}