# Stage environment values for networking
resource_group_name = "networking-stage-rg"
location            = "Central India"
environment         = "stage"

vnet_name          = "logtailer-stage-vnet"
vnet_address_space = "10.1.0.0/16"

# Public subnets
public_subnet1_name = "logtailer-stage-public-subnet-1"
public_subnet1_cidr = "10.1.1.0/24"
public_subnet2_name = "logtailer-stage-public-subnet-2"
public_subnet2_cidr = "10.1.2.0/24"

# Private subnets
private_subnet1_name = "logtailer-stage-private-subnet-1"
private_subnet1_cidr = "10.1.10.0/24"
private_subnet2_name = "logtailer-stage-private-subnet-2"
private_subnet2_cidr = "10.1.11.0/24"
