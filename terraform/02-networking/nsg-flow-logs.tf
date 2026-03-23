resource "azurerm_network_watcher" "main" {
  count               = var.enable_nsg_flow_logs ? 1 : 0
  name                = "nw-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  tags                = local.common_tags
}

resource "azurerm_network_watcher_flow_log" "private_subnet" {
  count                = var.enable_nsg_flow_logs ? 1 : 0
  name                 = "flowlog-private-subnet"
  network_watcher_name = azurerm_network_watcher.main[0].name
  resource_group_name  = var.foundation_resource_group_name
  network_security_group_id = azurerm_network_security_group.private.id
  storage_account_id        = var.flow_log_storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 30
  }

  traffic_analytics {
    enabled               = var.log_analytics_workspace_id != ""
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}
