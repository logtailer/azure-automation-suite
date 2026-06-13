foundation_resource_group_name = "azure-platform-dev-rg"

traffic_manager_name      = "tm-dev-platform"
routing_method            = "Priority"
probe_path                = "/health"
probe_interval_in_seconds = 10

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
