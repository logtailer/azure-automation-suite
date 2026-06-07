resource "azurerm_key_vault_certificate" "platform_tls" {
  count        = var.enable_tls_certificate ? 1 : 0
  name         = "platform-tls"
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }
      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage = [
        "cRLSign", "dataEncipherment", "digitalSignature",
        "keyAgreement", "keyCertSign", "keyEncipherment",
      ]
      subject            = var.tls_certificate_subject
      validity_in_months = 12
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "cert_expiry" {
  count               = var.enable_tls_certificate && var.enable_kv_alerts ? 1 : 0
  name                = "alert-cert-expiry-30d"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [azurerm_key_vault.main.id]
  severity            = 1
  frequency           = "PT1H"
  window_size         = "PT1H"

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "DaysUntilExpiry"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 30
  }

  tags = var.tags
}
