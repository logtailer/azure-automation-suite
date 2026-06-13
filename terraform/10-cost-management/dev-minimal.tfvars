foundation_resource_group_name = "azure-platform-dev-rg"

# Keep total budget under $20/session
subscription_budget_amount = 100
monthly_budget_amount      = 20
rg_budget_amount           = 20

alert_email = "anandsumit2000@gmail.com"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
