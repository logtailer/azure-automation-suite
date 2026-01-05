# Dev environment foundation configuration
location                        = "Central India"
resource_group_name             = "azure-platform-dev-rg"
tfstate_resource_group_name     = "terraform-state-rg"
tfstate_storage_account_name    = "sumittfstatestorage"
component_name                  = "foundation"

# Cost monitoring configuration
monthly_budget_amount    = 50    # $50/month budget for dev environment
cost_alert_threshold_1   = 50    # Alert at 50% ($25)
cost_alert_threshold_2   = 80    # Alert at 80% ($40)
cost_alert_threshold_3   = 100   # Alert at 100% ($50)
cost_alert_emails       = ["your-email@example.com"]  # Add your email here

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
