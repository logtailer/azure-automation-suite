# Dev environment foundation configuration
location                        = "Central India"
resource_group_name             = "azure-platform-dev-rg"
tfstate_resource_group_name     = "terraform-state-rg"
tfstate_storage_account_name    = "sumittfstatestorage"
component_name                  = "foundation"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
}
