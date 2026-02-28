resource "azurerm_log_analytics_workspace" "audit" {
  count               = var.enable_audit_workspace ? 1 : 0
  name                = "${var.log_analytics_workspace_name}-audit"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = var.audit_log_retention_days

  tags = var.tags
}

resource "azurerm_monitor_data_collection_rule" "platform" {
  count               = var.enable_data_collection_rule ? 1 : 0
  name                = "dcr-platform-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "primary-workspace"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["primary-workspace"]
  }

  tags = var.tags
}
