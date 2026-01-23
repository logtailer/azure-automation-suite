terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # No backend configuration - will be added dynamically during bootstrap
}

provider "azurerm" {
  features {}
}

# Resource group for the component
resource "azurerm_resource_group" "component" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.tags
}

# Resource group for terraform state (if it doesn't exist)
resource "azurerm_resource_group" "tfstate" {
  name     = var.tfstate_resource_group_name
  location = var.location
  
  tags = var.tags
}

# Storage account for terraform state
resource "azurerm_storage_account" "tfstate" {
  name                     = var.tfstate_storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Enable versioning for state file safety
  blob_properties {
    versioning_enabled = true
  }
  
  tags = var.tags
}

# Container for this component's state
resource "azurerm_storage_container" "component_state" {
  name                  = var.component_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
