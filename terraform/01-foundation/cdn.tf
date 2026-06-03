resource "azurerm_cdn_frontdoor_profile" "main" {
  count               = var.enable_front_door ? 1 : 0
  name                = "afd-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = var.front_door_sku
  tags                = local.common_tags
}

resource "azurerm_cdn_frontdoor_endpoint" "platform" {
  count                    = var.enable_front_door ? 1 : 0
  name                     = "platform-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[0].id
  tags                     = local.common_tags
}

resource "azurerm_cdn_frontdoor_origin_group" "aks" {
  count                    = var.enable_front_door ? 1 : 0
  name                     = "aks-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[0].id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/health"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}
