resource "azurerm_notification_hub_namespace" "main" {
  count               = var.enable_notification_hub ? 1 : 0
  name                = "nhns-${var.component_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  namespace_type      = "NotificationHub"
  sku_name            = var.notification_hub_sku

  tags = var.tags
}

resource "azurerm_notification_hub" "main" {
  count               = var.enable_notification_hub ? 1 : 0
  name                = "nh-${var.component_name}"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_notification_hub_namespace.main[0].name
  location            = var.location

  dynamic "apns_credential" {
    for_each = toset(compact([var.apns_bundle_id]))
    content {
      application_mode = var.apns_production ? "Production" : "Sandbox"
      bundle_id        = apns_credential.value
      key_id           = var.apns_key_id
      team_id          = var.apns_team_id
      token            = var.apns_token
    }
  }

  dynamic "gcm_credential" {
    for_each = toset(compact([var.gcm_api_key]))
    content {
      api_key = gcm_credential.value
    }
  }

  tags = var.tags
}
