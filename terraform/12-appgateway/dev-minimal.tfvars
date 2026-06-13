foundation_resource_group_name = "azure-platform-dev-rg"

vnet_name   = "vnet-dev"
subnet_name = "subnet-appgw"
appgw_name  = "agw-dev-platform"

# Detection mode — no blocking, cheap to run
waf_mode = "Detection"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
