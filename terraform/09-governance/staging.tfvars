# Staging environment governance configuration
subscription_id   = ""
allowed_locations = ["centralindia", "eastus"]

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
