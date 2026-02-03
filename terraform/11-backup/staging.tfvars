# Staging environment backup configuration
foundation_resource_group_name = "azure-platform-staging-rg"
vault_name                     = "backup-vault-staging"
vault_sku                      = "Standard"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "backup"
  CostCenter  = "engineering"
}
