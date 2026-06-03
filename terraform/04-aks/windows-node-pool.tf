resource "azurerm_kubernetes_cluster_node_pool" "windows" {
  count                 = var.enable_windows_node_pool ? 1 : 0
  name                  = "win"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = var.windows_node_vm_size
  node_count            = var.windows_node_count
  vnet_subnet_id        = var.vnet_subnet_id
  os_type               = "Windows"
  os_sku                = "Windows2022"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  max_pods              = 30

  node_labels = {
    "os"       = "windows"
    "workload" = "legacy"
  }

  node_taints = [
    "os=windows:NoSchedule",
  ]

  upgrade_settings {
    max_surge                     = "1"
    drain_timeout_in_minutes      = 30
    node_soak_duration_in_minutes = 0
  }

  tags = var.tags
}
