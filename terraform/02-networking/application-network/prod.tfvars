# Prod environment values for networking
resource_group_name   = "networking-prod-rg"
location             = "Central India"
environment          = "prod"

vnet_name            = "logtailer-prod-vnet"
vnet_address_space   = "10.2.0.0/16"

# Public subnets
public_subnet1_name  = "logtailer-prod-public-subnet-1"
public_subnet1_cidr  = "10.2.1.0/24"
public_subnet2_name  = "logtailer-prod-public-subnet-2"
public_subnet2_cidr  = "10.2.2.0/24"

# Private subnets
private_subnet1_name = "logtailer-prod-private-subnet-1"
private_subnet1_cidr = "10.2.10.0/24"
private_subnet2_name = "logtailer-prod-private-subnet-2"
private_subnet2_cidr = "10.2.11.0/24"
