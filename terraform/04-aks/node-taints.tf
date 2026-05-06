resource "azurerm_kubernetes_cluster_node_pool" "gpu" {
  count                 = var.enable_gpu_node_pool ? 1 : 0
  name                  = "gpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = var.gpu_node_vm_size
  node_count            = var.gpu_node_count
  vnet_subnet_id        = var.vnet_subnet_id
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  node_labels = {
    "accelerator" = "nvidia"
    "workload"    = "gpu"
  }
  node_taints = [
    "nvidia.com/gpu=present:NoSchedule",
  ]
  tags = var.tags
}
