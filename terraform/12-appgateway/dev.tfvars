# Dev environment Application Gateway configuration
foundation_resource_group_name = "azure-platform-dev-rg"
vnet_name                      = "azure-platform-dev-vnet"
subnet_name                    = "appgw-subnet-dev"
appgw_name                     = "appgw-platform-dev"
waf_mode                       = "Detection"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "appgateway"
  CostCenter  = "engineering"
}
