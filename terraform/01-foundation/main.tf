
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

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}


data "azurerm_storage_account" "existing" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group
}

resource "azurerm_storage_container" "component" {
  name                  = var.container_name
  storage_account_name  = data.azurerm_storage_account.existing.name
  container_access_type = "private"
}
