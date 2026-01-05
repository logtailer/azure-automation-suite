# Dev environment networking configuration
foundation_resource_group_name = "azure-platform-dev-rg"
vnet_name                      = "azure-platform-dev-vnet"
vnet_address_space            = ["10.0.0.0/16"]

# Subnet configurations
public_subnet_address_prefixes  = ["10.0.1.0/24"]
private_subnet_address_prefixes = ["10.0.2.0/24"]
aks_subnet_address_prefixes     = ["10.0.10.0/23"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "networking"
  CostCenter  = "engineering"
}
