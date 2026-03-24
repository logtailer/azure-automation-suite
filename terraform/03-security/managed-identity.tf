resource "azurerm_user_assigned_identity" "aks_workload" {
  count               = var.enable_workload_identity ? 1 : 0
  name                = "id-aks-workload-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "workload_kv_reader" {
  count                = var.enable_workload_identity ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_workload[0].principal_id
}

resource "azurerm_federated_identity_credential" "aks_workload" {
  count               = var.enable_workload_identity ? 1 : 0
  name                = "federated-aks-workload"
  resource_group_name = data.azurerm_resource_group.main.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_workload[0].id
  subject             = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}
