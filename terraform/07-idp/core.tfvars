# Internal Developer Platform (IDP) configuration
component_name               = "idp"
location                     = "Central India"
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# PostgreSQL Configuration
postgresql_server_name = "psql-backstage-platform-001"
db_admin_username      = "backstage_admin"
# SECURITY: db_admin_password must be provided via:
#   - Environment variable: TF_VAR_db_admin_password
#   - Command line: -var="db_admin_password=xxx"
#   - GitHub Secrets for CI/CD

# GitHub Integration
github_organization = "logtailer"
# SECURITY: The following must be provided via environment variables or secrets:
#   - TF_VAR_github_token (GitHub PAT with repo access)
#   - TF_VAR_github_client_id (GitHub OAuth App Client ID)
#   - TF_VAR_github_client_secret (GitHub OAuth App Client Secret)

# Azure Container Registry
container_registry_name = "acrbackstagecore001"

# Container Resources
container_cpu    = "1.0"
container_memory = "2.0"

# PostgreSQL Resources
postgresql_storage_mb            = 32768
postgresql_sku_name              = "B_Standard_B1ms"
postgresql_backup_retention_days = 7
postgresql_geo_redundant_backup  = false

# Azure AD Application
application_name = "Platform Engineering Portal"
homepage_url     = "https://backstage.your-domain.com"
redirect_uris = [
  "https://backstage.your-domain.com/api/auth/github/handler/frame"
]

# Azure AD Client Secret Expiration (1 year from deployment)
client_secret_end_date = "2027-12-31T23:59:59Z"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}

admin_group_name     = "Azure Platform Admins"
developer_group_name = "Azure Platform Developers"
viewer_group_name    = "Azure Platform Viewers"
