# Staging environment Traffic Manager configuration
foundation_resource_group_name = "azure-platform-staging-rg"
traffic_manager_name           = "tm-platform-staging"
routing_method                 = "Weighted"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "traffic-manager"
  CostCenter  = "engineering"
}
