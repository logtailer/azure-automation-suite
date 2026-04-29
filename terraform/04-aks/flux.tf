resource "azurerm_kubernetes_cluster_extension" "flux" {
  count             = var.enable_flux ? 1 : 0
  name              = "flux"
  cluster_id        = azurerm_kubernetes_cluster.cluster.id
  extension_type    = "microsoft.flux"

  configuration_settings = {
    "multiTenancy.enforce" = "false"
  }
}

resource "azurerm_kubernetes_flux_configuration" "platform" {
  count      = var.enable_flux ? 1 : 0
  name       = "platform-infra"
  cluster_id = azurerm_kubernetes_cluster.cluster.id
  namespace  = "flux-system"
  scope      = "cluster"

  git_repository {
    url                      = var.flux_git_repository_url
    reference_type           = "branch"
    reference_value          = "main"
    sync_interval_in_seconds = 60
    timeout_in_seconds       = 180
  }

  kustomizations {
    name                       = "platform-manifests"
    path                       = "./terraform/04-aks/k8s-manifests"
    sync_interval_in_seconds   = 300
    retry_interval_in_seconds  = 60
    garbage_collection_enabled = true
    depends_on                 = []
  }

  depends_on = [azurerm_kubernetes_cluster_extension.flux]
}
