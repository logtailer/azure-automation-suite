terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    recovery_services_vault {
      purge_protection_enabled = true
    }
  }
}

data "azurerm_resource_group" "foundation" {
  name = var.foundation_resource_group_name
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = var.vault_name
  location            = data.azurerm_resource_group.foundation.location
  resource_group_name = data.azurerm_resource_group.foundation.name
  sku                 = "Standard"
  soft_delete_enabled = true

  tags = var.tags
}

# Backup Policy for VMs (daily)
resource "azurerm_backup_policy_vm" "daily" {
  name                = "daily-vm-backup-policy"
  resource_group_name = data.azurerm_resource_group.foundation.name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}

# Backup Policy for File Shares
resource "azurerm_backup_policy_file_share" "daily" {
  name                = "daily-fileshare-backup-policy"
  resource_group_name = data.azurerm_resource_group.foundation.name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }
}
