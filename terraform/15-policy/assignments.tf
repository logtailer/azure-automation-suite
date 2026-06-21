data "azurerm_management_group" "root" {
  count = var.assign_at_management_group ? 1 : 0
  name  = var.management_group_id
}

resource "azurerm_management_group_policy_assignment" "baseline" {
  count                = var.assign_at_management_group ? 1 : 0
  name                 = "plat-sec-baseline"
  management_group_id  = data.azurerm_management_group.root[0].id
  policy_definition_id = azurerm_policy_set_definition.platform_baseline.id
  display_name         = "Platform Security Baseline (MG)"
  enforce              = var.enforce_policies

  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != "" ? toset(["enabled"]) : toset([])
    content {
      content = var.non_compliance_message
    }
  }
}
