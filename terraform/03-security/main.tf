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

# Certificate policy for automated certificate management
resource "azurerm_key_vault_certificate" "ssl_cert" {
  name         = "ssl-certificate"
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=platform.local"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = ["*.platform.local", "platform.local"]
      }
    }
  }

  depends_on = [azurerm_key_vault.main]
}
