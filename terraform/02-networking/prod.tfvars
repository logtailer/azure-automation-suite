# Production environment networking configuration
foundation_resource_group_name = "azure-platform-prod-rg"
vnet_name                      = "azure-platform-prod-vnet"
vnet_address_space            = ["10.2.0.0/15"]

# Subnet configurations — larger ranges for production workloads
public_subnet_address_prefixes  = ["10.2.1.0/24"]
private_subnet_address_prefixes = ["10.2.2.0/23"]
aks_subnet_address_prefixes     = ["10.2.10.0/22"]

enable_ddos_protection = true

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "networking"
  CostCenter  = "engineering"
}
