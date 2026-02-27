resource "null_resource" "istio_install" {
  count = var.enable_istio ? 1 : 0

  triggers = {
    cluster_id   = azurerm_kubernetes_cluster.cluster.id
    istio_version = var.istio_version
  }

  provisioner "local-exec" {
    command = <<-EOT
      az aks mesh enable \
        --resource-group ${azurerm_kubernetes_cluster.cluster.resource_group_name} \
        --name ${azurerm_kubernetes_cluster.cluster.name} \
        --revision ${var.istio_version}
    EOT
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}
