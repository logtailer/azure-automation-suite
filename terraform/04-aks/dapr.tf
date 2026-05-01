resource "azurerm_kubernetes_cluster_extension" "dapr" {
  count          = var.enable_dapr ? 1 : 0
  name           = "dapr"
  cluster_id     = azurerm_kubernetes_cluster.cluster.id
  extension_type = "microsoft.dapr"

  configuration_settings = {
    "global.ha.enabled"                = "true"
    "dapr_operator.replicaCount"       = "2"
    "dapr_sidecar_injector.replicaCount" = "2"
    "dapr_sentry.replicaCount"         = "2"
  }
}
