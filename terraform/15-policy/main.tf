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

data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "deny_public_storage" {
  name         = "deny-public-storage-access"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny public access on storage accounts"

  policy_rule = file("${path.module}/definitions/deny-public-storage.json")
}

resource "azurerm_policy_definition" "require_https_storage" {
  name         = "require-https-storage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require HTTPS on storage accounts"

  policy_rule = file("${path.module}/definitions/require-https-storage.json")
}

resource "azurerm_policy_definition" "deny_ssh_rdp_from_internet" {
  name         = "deny-ssh-rdp-from-internet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny SSH and RDP inbound from Internet"

  policy_rule = file("${path.module}/definitions/deny-ssh-rdp-internet.json")
}

resource "azurerm_policy_definition" "require_tags" {
  name         = "require-platform-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require platform tags on all resources"

  policy_rule = file("${path.module}/definitions/require-tags.json")
}

resource "azurerm_policy_set_definition" "platform_baseline" {
  name         = "platform-security-baseline"
  policy_type  = "Custom"
  display_name = "Platform Security Baseline"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_storage.id
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_https_storage.id
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_ssh_rdp_from_internet.id
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tags.id
  }
}

resource "azurerm_policy_definition" "audit_keyvault_soft_delete" {
  name         = "audit-keyvault-soft-delete"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Key Vault soft delete and purge protection"

  parameters = jsonencode({
    effect = {
      type         = "String"
      metadata     = { displayName = "Effect" }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = file("${path.module}/definitions/audit-keyvault-soft-delete.json")
}

resource "azurerm_policy_definition" "deny_unapproved_vm_skus" {
  name         = "deny-unapproved-vm-skus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny unapproved VM SKUs"

  parameters = jsonencode({
    allowedSkus = {
      type     = "Array"
      metadata = { displayName = "Allowed VM SKUs", description = "List of permitted VM SKU names" }
      defaultValue = ["Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3", "Standard_E4s_v3"]
    }
    effect = {
      type         = "String"
      metadata     = { displayName = "Effect" }
      allowedValues = ["Deny", "Audit", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = file("${path.module}/definitions/deny-unapproved-vm-skus.json")
}

resource "azurerm_policy_definition" "require_diagnostic_settings" {
  name         = "require-diagnostic-settings"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require diagnostic settings on critical Azure resources"

  parameters = jsonencode({
    effect = {
      type         = "String"
      metadata     = { displayName = "Effect" }
      allowedValues = ["Audit", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = file("${path.module}/definitions/require-diagnostic-settings.json")
}

resource "azurerm_policy_definition" "deny_public_ip_on_nic" {
  name         = "deny-public-ip-on-nic"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny public IP addresses on network interfaces"

  parameters = jsonencode({
    effect = {
      type         = "String"
      metadata     = { displayName = "Effect" }
      allowedValues = ["Deny", "Audit", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = file("${path.module}/definitions/deny-public-ip-on-nic.json")
}

resource "azurerm_subscription_policy_assignment" "baseline" {
  name                 = "platform-security-baseline"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_set_definition.platform_baseline.id
  display_name         = "Platform Security Baseline"
  enforce              = var.enforce_policies
}
