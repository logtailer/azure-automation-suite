data "azurerm_container_registry" "main" {
  count               = var.acr_name != "" ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_name != "" ? 1 : 0
  scope                = data.azurerm_container_registry.main[0].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
}
