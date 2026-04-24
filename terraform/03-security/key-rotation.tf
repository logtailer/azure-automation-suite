resource "azurerm_key_vault_key" "platform_cmk" {
  count        = var.enable_customer_managed_key ? 1 : 0
  name         = "cmk-platform-${var.environment}"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P365D"
    notify_before_expiry = "P30D"
  }

  tags = var.tags
}
