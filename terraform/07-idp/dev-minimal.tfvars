location            = "Central India"
resource_group_name = "idp-dev-rg"
environment         = "dev"

tfstate_resource_group  = "terraform-state-rg"
tfstate_storage_account = "sumittfstatestorage"

# Backstage container registry
container_registry_name = "acrdevplatform001"

# PostgreSQL backend for Backstage
postgresql_server_name = "psql-backstage-dev"
db_admin_username      = "backstageadmin"
db_admin_password      = "REPLACE_ME_strong_password_123!"

# GitHub OAuth — fill in before deploying
github_token         = "REPLACE_ME"
github_organization  = "REPLACE_ME"
github_client_id     = "REPLACE_ME"
github_client_secret = "REPLACE_ME"

# Azure AD app registration
application_name = "backstage-dev"
homepage_url     = "http://localhost:7007"
redirect_uris    = ["http://localhost:7007/api/auth/microsoft/handler/frame"]

# Groups — use existing Azure AD groups or create new ones
admin_group_name     = "backstage-admins"
developer_group_name = "backstage-developers"
viewer_group_name    = "backstage-viewers"

# Budget
enable_component_budget = false
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["anandsumit2000@gmail.com"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
