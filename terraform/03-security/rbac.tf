# Role-Based Access Control (RBAC) Assignments
# Enterprise-grade access management for identities and security principals

# Grant Key Vault Secrets User to AKS workload identity
resource "azurerm_role_assignment" "aks_kv_secrets" {
  count                = var.enable_aks_identity ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_workload[0].principal_id
}

# Grant Key Vault Secrets User to app workload identity
resource "azurerm_role_assignment" "app_kv_secrets" {
  count                = var.enable_app_identity ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app_workload[0].principal_id
}

# Grant Key Vault Administrator to DevOps identity (for secret management)
resource "azurerm_role_assignment" "devops_kv_admin" {
  count                = var.enable_devops_identity ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.devops[0].principal_id
}

# Grant Monitoring Reader to monitoring identity
resource "azurerm_role_assignment" "monitoring_reader" {
  count                = var.enable_monitoring_identity ? 1 : 0
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_user_assigned_identity.monitoring[0].principal_id
}

# Grant Reader role to monitoring identity for resource access
resource "azurerm_role_assignment" "monitoring_resource_reader" {
  count                = var.enable_monitoring_identity ? 1 : 0
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.monitoring[0].principal_id
}

# Optional: Grant custom roles for specific workloads
resource "azurerm_role_assignment" "custom_workload_roles" {
  for_each             = var.custom_role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = each.value.principal_id
}
