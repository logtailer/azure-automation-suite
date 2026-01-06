# Internal Developer Platform (IDP) configuration  
resource_group_name = "rg-idp"
location            = "East US"

tfstate_resource_group  = "terraform-state"
tfstate_storage_account = "sumittfstatestorage"

postgresql_server_name = "psql-backstage-platform-001"
db_admin_username      = "backstage_admin"
db_admin_password      = "P@ssw0rd123!" # Change this in production

github_organization  = "logtailer"
github_token         = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # Add your GitHub PAT
github_client_id     = "your-github-oauth-client-id"
github_client_secret = "your-github-oauth-client-secret"

tags = {
  Environment = "Production"
  Project     = "Platform"
  Component   = "Internal-Developer-Platform"
  Tool        = "Backstage"
}

admin_group_name     = "Azure Platform Admins"
developer_group_name = "Azure Platform Developers"
viewer_group_name    = "Azure Platform Viewers"
