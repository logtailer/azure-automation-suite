terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Data sources
data "azurerm_subscription" "current" {}

# Azure Policy Assignment - Require tags on resources
resource "azurerm_policy_assignment" "require_tags" {
  name                 = "require-tags-policy"
  scope                = data.azurerm_subscription.current.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"
  description          = "Require specified tags on resources"
  display_name         = "Require tags on resources"

  parameters = jsonencode({
    tagNames = {
      value = ["Environment", "Owner", "Project"]
    }
  })
}

# Azure Policy Assignment - Allowed locations
resource "azurerm_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations-policy"
  scope                = data.azurerm_subscription.current.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  description          = "Restrict resource deployment to specific Azure regions"
  display_name         = "Allowed locations for resources"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["eastus", "westus2", "centralindia"]
    }
  })
}

# Azure Policy Assignment - Require encryption for storage accounts
resource "azurerm_policy_assignment" "storage_encryption" {
  name                 = "storage-encryption-policy"
  scope                = data.azurerm_subscription.current.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  description          = "Require secure transfer for storage accounts"
  display_name         = "Secure transfer to storage accounts should be enabled"
}
