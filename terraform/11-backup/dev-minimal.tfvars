foundation_resource_group_name = "azure-platform-dev-rg"

vault_name         = "rsv-dev-platform"
vault_sku          = "Standard"
backup_policy_name = "daily-vm-backup-policy"

# Disable cross-region restore (doubles storage cost)
enable_cross_region_restore = false

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
