resource "azurerm_user_assigned_identity" "workload" {
  count               = var.enable_workload_identity ? 1 : 0
  name                = "id-workload-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}
