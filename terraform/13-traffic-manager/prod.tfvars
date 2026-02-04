# Production environment Traffic Manager configuration
foundation_resource_group_name = "azure-platform-prod-rg"
traffic_manager_name           = "tm-platform-prod"
routing_method                 = "Performance"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "traffic-manager"
  CostCenter  = "engineering"
}
