# Production environment governance configuration
subscription_id   = ""
allowed_locations = ["centralindia"]

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
  Compliance  = "required"
}
