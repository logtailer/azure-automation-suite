# Staging environment networking configuration
foundation_resource_group_name = "azure-platform-staging-rg"
vnet_name                      = "azure-platform-staging-vnet"
vnet_address_space            = ["10.1.0.0/16"]

# Subnet configurations
public_subnet_address_prefixes  = ["10.1.1.0/24"]
private_subnet_address_prefixes = ["10.1.2.0/24"]
aks_subnet_address_prefixes     = ["10.1.10.0/23"]

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "networking"
  CostCenter  = "engineering"
}
