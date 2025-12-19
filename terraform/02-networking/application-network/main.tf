# Azure Networking Infrastructure
# This module creates the core networking components including VNet, subnets, and NAT Gateway

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}


# Networking Resource Group
resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "core_vpc" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}


# Public Subnet 1
resource "azurerm_subnet" "public1" {
  name                            = var.public_subnet1_name
  resource_group_name             = azurerm_resource_group.network.name
  virtual_network_name            = azurerm_virtual_network.core_vpc.name
  address_prefixes                = [var.public_subnet1_cidr]
  default_outbound_access_enabled = true
}

# Public Subnet 2
resource "azurerm_subnet" "public2" {
  name                            = var.public_subnet2_name
  resource_group_name             = azurerm_resource_group.network.name
  virtual_network_name            = azurerm_virtual_network.core_vpc.name
  address_prefixes                = [var.public_subnet2_cidr]
  default_outbound_access_enabled = true
}

# Private Subnet 1
resource "azurerm_subnet" "private1" {
  name                 = var.private_subnet1_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.core_vpc.name
  address_prefixes     = [var.private_subnet1_cidr]
}

# Private Subnet 2
resource "azurerm_subnet" "private2" {
  name                 = var.private_subnet2_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.core_vpc.name
  address_prefixes     = [var.private_subnet2_cidr]
}


# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  name                = "${var.environment}-nat-gateway-pip"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# NAT Gateway for private subnet
resource "azurerm_nat_gateway" "main" {
  name                = "${var.environment}-nat-gateway"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  sku_name            = "Standard"

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# Associate Public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}


# Associate NAT Gateway with private subnets
resource "azurerm_subnet_nat_gateway_association" "private1" {
  subnet_id      = azurerm_subnet.private1.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

resource "azurerm_subnet_nat_gateway_association" "private2" {
  subnet_id      = azurerm_subnet.private2.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Network Security Group for public subnet
resource "azurerm_network_security_group" "public" {
  name                = "${var.environment}-public-nsg"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# Network Security Group for private subnet
resource "azurerm_network_security_group" "private" {
  name                = "${var.environment}-private-nsg"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "public1" {
  subnet_id                 = azurerm_subnet.public1.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "public2" {
  subnet_id                 = azurerm_subnet.public2.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private1" {
  subnet_id                 = azurerm_subnet.private1.id
  network_security_group_id = azurerm_network_security_group.private.id
}

resource "azurerm_subnet_network_security_group_association" "private2" {
  subnet_id                 = azurerm_subnet.private2.id
  network_security_group_id = azurerm_network_security_group.private.id
}

# VM-specific networking components
# Public IP for VM
resource "azurerm_public_ip" "vm_ip" {
  name                = "${var.environment}-vm-public-ip"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}

# Network Interface for VM (using public1 subnet)
resource "azurerm_network_interface" "vm_interface" {
  name                = "${var.environment}-vm-interface"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  ip_configuration {
    name                          = "vm-interface-ip"
    subnet_id                     = azurerm_subnet.public1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }

  tags = {
    Environment = var.environment
    # Project     = var.project_name
    Component   = "networking"
  }
}
