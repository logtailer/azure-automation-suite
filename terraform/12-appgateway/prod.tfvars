# Production environment Application Gateway configuration
foundation_resource_group_name = "azure-platform-prod-rg"
vnet_name                      = "azure-platform-prod-vnet"
subnet_name                    = "appgw-subnet-prod"
appgw_name                     = "appgw-platform-prod"
waf_mode                       = "Prevention"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "appgateway"
  CostCenter  = "engineering"
}
