# Grafana Dashboard Configuration
resource "azurerm_dashboard_grafana" "main" {
  name                              = var.grafana_name
  resource_group_name               = data.azurerm_resource_group.main.name
  location                          = data.azurerm_resource_group.main.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Grant Grafana access to monitoring data
resource "azurerm_role_assignment" "grafana_reader" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity.0.principal_id
}

resource "azurerm_role_assignment" "grafana_data_reader" {
  scope                = azurerm_log_analytics_workspace.main.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity.0.principal_id
}
