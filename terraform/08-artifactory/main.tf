# Terraform configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Backend configuration will be provided via -backend-config during init
}

provider "azurerm" {
  features {}
}

# Data sources
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Random suffix for DNS label uniqueness
resource "random_id" "dns_suffix" {
  byte_length = 4
}

# Random suffix for storage account name uniqueness
resource "random_id" "storage_suffix" {
  byte_length = 3
}

# User-Assigned Managed Identity for Nexus container
resource "azurerm_user_assigned_identity" "nexus" {
  name                = "id-nexus-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Azure Container Registry for Nexus images
resource "azurerm_container_registry" "nexus" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = var.container_registry_sku
  admin_enabled       = false

  tags = var.tags
}

# Grant AcrPull role to managed identity
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.nexus.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.nexus.principal_id
}
