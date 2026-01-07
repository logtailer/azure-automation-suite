# Azure Policy and Resource Locks
# Enterprise governance and compliance controls

# Resource lock on Key Vault to prevent accidental deletion
resource "azurerm_management_lock" "keyvault" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-keyvault-${var.environment}"
  scope      = azurerm_key_vault.main.id
  lock_level = var.lock_level
  notes      = "Prevents accidental deletion of Key Vault containing critical secrets"
}

# Resource lock on resource group (optional)
resource "azurerm_management_lock" "resource_group" {
  count      = var.enable_rg_lock ? 1 : 0
  name       = "lock-security-rg-${var.environment}"
  scope      = data.azurerm_resource_group.main.id
  lock_level = var.lock_level
  notes      = "Prevents accidental deletion of security resource group"
}

# Policy: Require tags on resources
resource "azurerm_resource_group_policy_assignment" "require_tags" {
  count                = var.enable_tag_policy ? 1 : 0
  name                 = "require-tags-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

# Policy: Require SSL/TLS for storage accounts
resource "azurerm_resource_group_policy_assignment" "require_https" {
  count                = var.enable_https_policy ? 1 : 0
  name                 = "require-https-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
}

# Policy: Audit Key Vault without purge protection
resource "azurerm_resource_group_policy_assignment" "audit_kv_purge" {
  count                = var.enable_kv_purge_policy ? 1 : 0
  name                 = "audit-kv-purge-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
}

# Policy: Require Azure Defender for Key Vault
resource "azurerm_resource_group_policy_assignment" "defender_keyvault" {
  count                = var.enable_defender_policy ? 1 : 0
  name                 = "defender-keyvault-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1f725891-01c0-420a-9059-4fa46cb770b7"
}

# Custom policy: Block public network access to Key Vault
resource "azurerm_resource_group_policy_assignment" "block_kv_public" {
  count                = var.enable_kv_public_block_policy ? 1 : 0
  name                 = "block-kv-public-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490"
}
