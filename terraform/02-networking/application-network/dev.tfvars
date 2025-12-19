# Dev environment values for networking
resource_group_name   = "networking-dev-rg"
location             = "Central India"
environment          = "dev"

vnet_name            = "logtailer-dev-vnet"
vnet_address_space   = "10.0.0.0/16"

# Public subnets
public_subnet1_name  = "logtailer-dev-public-subnet-1"
public_subnet1_cidr  = "10.0.1.0/24"
public_subnet2_name  = "logtailer-dev-public-subnet-2"
public_subnet2_cidr  = "10.0.2.0/24"

# Private subnets
private_subnet1_name = "logtailer-dev-private-subnet-1"
private_subnet1_cidr = "10.0.10.0/24"
private_subnet2_name = "logtailer-dev-private-subnet-2"
private_subnet2_cidr = "10.0.11.0/24"
