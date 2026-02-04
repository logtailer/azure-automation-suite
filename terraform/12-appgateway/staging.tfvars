# Staging environment Application Gateway configuration
foundation_resource_group_name = "azure-platform-staging-rg"
vnet_name                      = "azure-platform-staging-vnet"
subnet_name                    = "appgw-subnet-staging"
appgw_name                     = "appgw-platform-staging"
waf_mode                       = "Prevention"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "appgateway"
  CostCenter  = "engineering"
}
