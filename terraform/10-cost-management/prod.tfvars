# Production environment cost management configuration
foundation_resource_group_name = "azure-platform-prod-rg"
monthly_budget_amount          = 2000
rg_budget_amount               = 1000
alert_email                    = "platform-team@example.com"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
