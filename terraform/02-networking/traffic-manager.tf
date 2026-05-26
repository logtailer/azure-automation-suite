resource "azurerm_traffic_manager_profile" "main" {
  count               = var.enable_traffic_manager ? 1 : 0
  name                = "tm-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name

  traffic_routing_method = var.tm_routing_method

  dns_config {
    relative_name = var.tm_dns_relative_name
    ttl           = 30
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = var.tm_health_probe_path
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "primary" {
  count              = var.enable_traffic_manager ? 1 : 0
  name               = "endpoint-primary"
  profile_id         = azurerm_traffic_manager_profile.main[0].id
  target_resource_id = var.tm_primary_endpoint_resource_id
  weight             = var.tm_routing_method == "Weighted" ? var.tm_primary_weight : null
  priority           = var.tm_routing_method == "Priority" ? 1 : null
  enabled            = true
}

resource "azurerm_traffic_manager_azure_endpoint" "secondary" {
  count              = var.enable_traffic_manager && var.tm_secondary_endpoint_resource_id != "" ? 1 : 0
  name               = "endpoint-secondary"
  profile_id         = azurerm_traffic_manager_profile.main[0].id
  target_resource_id = var.tm_secondary_endpoint_resource_id
  weight             = var.tm_routing_method == "Weighted" ? (100 - var.tm_primary_weight) : null
  priority           = var.tm_routing_method == "Priority" ? 2 : null
  enabled            = true
}
