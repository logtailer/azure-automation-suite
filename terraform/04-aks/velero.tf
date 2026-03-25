resource "azurerm_storage_account" "velero" {
  count                    = var.enable_velero ? 1 : 0
  name                     = "stvelero${replace(var.cluster_name, "-", "")}${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "velero" {
  count                 = var.enable_velero ? 1 : 0
  name                  = "velero"
  storage_account_id    = azurerm_storage_account.velero[0].id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "velero" {
  count               = var.enable_velero ? 1 : 0
  name                = "id-velero-${var.cluster_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "velero_storage" {
  count                = var.enable_velero ? 1 : 0
  scope                = azurerm_storage_account.velero[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.velero[0].principal_id
}
