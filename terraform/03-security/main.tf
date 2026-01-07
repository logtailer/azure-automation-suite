terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # Backend configuration will be provided via -backend-config during init
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = var.purge_soft_delete_on_destroy
      recover_soft_deleted_key_vaults = var.recover_soft_deleted_key_vaults
    }
  }
}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Azure Key Vault - Enterprise Configuration
resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  enabled_for_deployment      = var.enabled_for_deployment
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  sku_name                    = var.sku_name

  # Network ACLs for security
  network_acls {
    bypass         = "AzureServices"
    default_action = var.default_network_action
    ip_rules       = var.allowed_ip_ranges
  }

  # Enable RBAC authorization
  enable_rbac_authorization = var.enable_rbac_authorization

  tags = var.tags
}

# SSH Public Key Secret (example secret)
resource "azurerm_key_vault_secret" "ssh_public_key" {
  count        = var.ssh_public_key != "" ? 1 : 0
  name         = "ssh-public-key"
  value        = var.ssh_public_key
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault.main]

  tags = var.tags
}
