# Production environment backup configuration
foundation_resource_group_name = "azure-platform-prod-rg"
vault_name                     = "backup-vault-prod"
vault_sku                      = "RS0"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "backup"
  CostCenter  = "engineering"
  Compliance  = "required"
}
