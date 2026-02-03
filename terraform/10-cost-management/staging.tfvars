# Staging environment cost management configuration
foundation_resource_group_name = "azure-platform-staging-rg"
monthly_budget_amount          = 500
rg_budget_amount               = 250
alert_email                    = "platform-team@example.com"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
