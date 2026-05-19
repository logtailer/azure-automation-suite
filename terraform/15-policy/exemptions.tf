resource "azurerm_resource_policy_exemption" "dev_vm_sku" {
  count                = var.create_dev_sku_exemption ? 1 : 0
  name                 = "dev-vm-sku-exemption"
  resource_id          = var.dev_vm_resource_id
  policy_assignment_id = azurerm_subscription_policy_assignment.deny_unapproved_vm_skus[0].id
  exemption_category   = "Waiver"
  description          = "Development VM uses non-standard SKU for cost optimisation"
  expires_on           = var.dev_exemption_expiry

  metadata = jsonencode({
    requestedBy   = "platform-team"
    approvedBy    = "security-team"
    ticketRef     = var.dev_exemption_ticket_ref
  })
}

resource "azurerm_resource_group_policy_exemption" "legacy_rg" {
  count                = var.create_legacy_rg_exemption ? 1 : 0
  name                 = "legacy-rg-exemption"
  resource_group_id    = var.legacy_resource_group_id
  policy_assignment_id = azurerm_subscription_policy_assignment.require_tags[0].id
  exemption_category   = "Mitigated"
  description          = "Legacy resource group migrating to new tagging standard by Q3"
  expires_on           = var.legacy_exemption_expiry

  metadata = jsonencode({
    migrationPlan = "https://wiki.example.com/legacy-rg-migration"
    ownerTeam     = "legacy-services"
  })
}
