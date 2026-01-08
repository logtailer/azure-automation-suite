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

# Get the foundation resource group
data "azurerm_resource_group" "foundation" {
  name = var.foundation_resource_group_name
}

# Create VNet for networking
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name

  tags = var.tags
}

# Public subnet for load balancers, NAT gateway
resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = data.azurerm_resource_group.foundation.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.public_subnet_address_prefixes
}

# Private subnet for applications
resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = data.azurerm_resource_group.foundation.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_subnet_address_prefixes
}

# AKS subnet for Kubernetes nodes
resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = data.azurerm_resource_group.foundation.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

# AKS CI/CD subnet for GitHub runners cluster
resource "azurerm_subnet" "aks_cicd" {
  name                 = "snet-aks-cicd"
  resource_group_name  = data.azurerm_resource_group.foundation.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_cicd_subnet_address_prefixes

  # AKS-specific service endpoints
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.Storage"
  ]
}

# Network Security Group for public subnet
resource "azurerm_network_security_group" "public" {
  name                = "public-nsg"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name

  # Allow HTTP/HTTPS inbound
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

  tags = var.tags
}

# Network Security Group for private subnet
resource "azurerm_network_security_group" "private" {
  name                = "private-nsg"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name

  # Deny all inbound from internet
  security_rule {
    name                       = "DenyInternetInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with public subnet
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

# Associate NSG with private subnet
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

# NAT Gateway for outbound internet access from private subnets
resource "azurerm_public_ip" "nat_gateway" {
  name                = "nat-gateway-pip"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "main" {
  name                = "nat-gateway"
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  sku_name            = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

resource "azurerm_subnet_nat_gateway_association" "aks" {
  subnet_id      = azurerm_subnet.aks.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_cicd" {
  subnet_id      = azurerm_subnet.aks_cicd.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}
