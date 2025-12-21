output "aks_cluster_name" {
  description = "Name of the AKS cluster for GitHub runners"
  value       = azurerm_kubernetes_cluster.github_runners.name
}

output "aks_kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.github_runners.kube_config_raw
  sensitive   = true
}

output "aks_node_resource_group" {
  description = "Node resource group for the AKS cluster"
  value       = azurerm_kubernetes_cluster.github_runners.node_resource_group
}
