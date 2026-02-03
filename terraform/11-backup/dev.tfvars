# Dev environment backup configuration
foundation_resource_group_name = "azure-platform-dev-rg"
vault_name                     = "backup-vault-dev"
vault_sku                      = "Standard"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "backup"
  CostCenter  = "engineering"
}
