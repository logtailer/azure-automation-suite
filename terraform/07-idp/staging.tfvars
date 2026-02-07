# Internal Developer Platform (IDP) - Staging Environment
resource_group_name = "rg-platform-staging-centralindia"
location            = "centralindia"
environment         = "staging"

container_registry_name = "acrbackstagestaging001"

tfstate_resource_group  = "rg-tfstate-staging-centralindia"
tfstate_storage_account = "stterraformstaging001"

postgresql_server_name = "psql-backstage-staging-001"
db_admin_username      = "backstage_admin"

github_organization = "logtailer"

application_name = "Platform Engineering Portal - Staging"
homepage_url     = "https://backstage-staging.your-domain.com"
redirect_uris = [
  "https://backstage-staging.your-domain.com/api/auth/github/handler/frame"
]

admin_group_name     = "Platform Admins - Staging"
developer_group_name = "Platform Developers - Staging"
viewer_group_name    = "Platform Viewers - Staging"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  Component   = "idp"
  Tool        = "backstage"
  ManagedBy   = "terraform"
  CostCenter  = "platform-engineering"
}
