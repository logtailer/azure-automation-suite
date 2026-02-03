# Dev environment cost management configuration
foundation_resource_group_name = "azure-platform-dev-rg"
monthly_budget_amount          = 100
rg_budget_amount               = 50
alert_email                    = "platform-team@example.com"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
