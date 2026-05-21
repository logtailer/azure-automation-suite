resource "azurerm_monitor_data_collection_rule" "prometheus" {
  count               = var.enable_prometheus_collection ? 1 : 0
  name                = "dcr-prometheus-${var.resource_group_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  description         = "Collect Prometheus metrics from AKS and forward to Azure Monitor workspace"

  destinations {
    monitor_account {
      monitor_account_id = var.azure_monitor_workspace_id
      name               = "MonitoringAccount"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount"]
  }

  data_sources {
    prometheus_forwarder {
      name    = "PrometheusDataSource"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_data_collection_rule_association" "aks" {
  count                   = var.enable_prometheus_collection && var.aks_cluster_id != "" ? 1 : 0
  name                    = "dcra-aks-prometheus"
  target_resource_id      = var.aks_cluster_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.prometheus[0].id
  description             = "Associate AKS cluster with Prometheus data collection rule"
}
