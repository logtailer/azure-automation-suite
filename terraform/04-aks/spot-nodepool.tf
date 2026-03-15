resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  count                 = var.spot_node_pool_enabled ? 1 : 0
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = var.spot_node_pool_vm_size
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = -1
  auto_scaling_enabled  = true
  min_count             = 0
  max_count             = 10
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
  tags        = var.tags
}
