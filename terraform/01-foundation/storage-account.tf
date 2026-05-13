resource "azurerm_storage_account" "platform" {
  count                             = var.enable_platform_storage ? 1 : 0
  name                              = var.platform_storage_account_name
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  account_tier                      = "Standard"
  account_replication_type          = var.platform_storage_replication
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  public_network_access_enabled     = false
  shared_access_key_enabled         = true
  infrastructure_encryption_enabled = true
  tags                              = local.common_tags

  blob_properties {
    versioning_enabled       = true
    change_feed_enabled      = true
    last_access_time_enabled = true

    delete_retention_policy {
      days = 14
    }

    container_delete_retention_policy {
      days = 14
    }
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}

resource "azurerm_storage_container" "artifacts" {
  count                 = var.enable_platform_storage ? 1 : 0
  name                  = "artifacts"
  storage_account_id    = azurerm_storage_account.platform[0].id
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups" {
  count                 = var.enable_platform_storage ? 1 : 0
  name                  = "backups"
  storage_account_id    = azurerm_storage_account.platform[0].id
  container_access_type = "private"
}
