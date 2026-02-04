# Dev environment Traffic Manager configuration
foundation_resource_group_name = "azure-platform-dev-rg"
traffic_manager_name           = "tm-platform-dev"
routing_method                 = "Priority"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "traffic-manager"
  CostCenter  = "engineering"
}
