# Azure Monitor Workspace for Prometheus-compatible metrics
# Note: Azure Monitor managed service for Prometheus is the Azure-native approach
# This integrates with Grafana without needing custom exporters

# Azure Monitor Workspace (for Prometheus metrics)
resource "azurerm_monitor_workspace" "prometheus" {
  count               = var.enable_prometheus_metrics ? 1 : 0
  name                = "amw-prometheus-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Link Grafana to Prometheus workspace
resource "azurerm_grafana_managed_private_endpoint" "prometheus" {
  count                    = var.enable_prometheus_metrics ? 1 : 0
  grafana_id               = azurerm_dashboard_grafana.main.id
  name                     = "prometheus-endpoint"
  location                 = data.azurerm_resource_group.main.location
  private_link_resource_id = azurerm_monitor_workspace.prometheus[0].id
  group_ids                = ["prometheusMetrics"]

  # Note: This creates a Grafana data source for Azure Monitor Prometheus
}

# Documentation on using Azure Monitor for Prometheus:
# 1. Azure Monitor Workspace provides Prometheus-compatible endpoint
# 2. Grafana automatically connects via managed private endpoint
# 3. No need for custom exporters - Azure Monitor collects metrics natively
# 4. Query using PromQL in Grafana dashboards
# 5. Supports Container Insights metrics in Prometheus format
