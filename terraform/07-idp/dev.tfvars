# Internal Developer Platform (IDP) - Development Environment
# Reference foundation outputs for resource group
resource_group_name = "rg-platform-dev-centralindia"
location            = "centralindia"
environment         = "dev"

# Azure Container Registry for Backstage images
container_registry_name = "acrbackstagedev001"

# Backend configuration - matches foundation
tfstate_resource_group_name     = "terraform-state-rg"
tfstate_storage_account_name    = "sumittfstatestorage"

# PostgreSQL for Backstage
postgresql_server_name = "psql-backstage-dev-001"
db_admin_username      = "backstage_admin"
# This will be provided via GitHub secrets
# db_admin_password = ""

# GitHub Integration - Update with your details
github_organization = "logtailer" # Your GitHub username/org
# These will be provided via GitHub secrets:
# github_token = ""           # GitHub PAT with repo access
# github_client_id = ""       # GitHub OAuth App Client ID  
# github_client_secret = ""   # GitHub OAuth App Client Secret

# Azure AD Application
application_name = "Platform Engineering Portal - Dev"
homepage_url     = "https://backstage-dev.your-domain.com"
redirect_uris = [
  "https://backstage-dev.your-domain.com/api/auth/github/handler/frame",
  "http://localhost:3000/api/auth/github/handler/frame" # For local development
]

# Azure AD Groups
admin_group_name     = "Platform Admins - Dev"
developer_group_name = "Platform Developers - Dev"
viewer_group_name    = "Platform Viewers - Dev"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  Component   = "idp"
  Tool        = "backstage"
  ManagedBy   = "terraform"
  CostCenter  = "platform-engineering"
}
