# Internal Developer Platform (IDP) - Production Environment
resource_group_name = "rg-platform-prod-centralindia"
location            = "centralindia"
environment         = "prod"

container_registry_name = "acrbackstageprod001"

tfstate_resource_group  = "rg-tfstate-prod-centralindia"
tfstate_storage_account = "stterraformprod001"

postgresql_server_name = "psql-backstage-prod-001"
db_admin_username      = "backstage_admin"

github_organization = "logtailer"

application_name = "Platform Engineering Portal"
homepage_url     = "https://backstage.your-domain.com"
redirect_uris = [
  "https://backstage.your-domain.com/api/auth/github/handler/frame"
]

admin_group_name     = "Platform Admins"
developer_group_name = "Platform Developers"
viewer_group_name    = "Platform Viewers"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  Component   = "idp"
  Tool        = "backstage"
  ManagedBy   = "terraform"
  CostCenter  = "platform-engineering"
}
