# AKS outputs
output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.cicd.name
}

output "aks_cluster_id" {
  description = "AKS cluster resource ID"
  value       = azurerm_kubernetes_cluster.cicd.id
}

output "aks_fqdn" {
  description = "AKS cluster FQDN"
  value       = azurerm_kubernetes_cluster.cicd.fqdn
}

output "aks_kube_config" {
  description = "Kubernetes config for kubectl access"
  value       = azurerm_kubernetes_cluster.cicd.kube_config_raw
  sensitive   = true
}

# ArgoCD outputs
output "argocd_url" {
  description = "ArgoCD server URL"
  value       = "http://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip}"
}

output "argocd_admin_password" {
  description = "ArgoCD admin password (initial)"
  value       = data.kubernetes_secret.argocd_admin_password.data["password"]
  sensitive   = true
}

# Actions Runner Controller outputs
output "arc_namespace" {
  description = "ARC namespace"
  value       = kubernetes_namespace.arc_system.metadata[0].name
}

output "runner_scale_set_name" {
  description = "Runner scale set name for GitHub"
  value       = var.runner_scale_set_name
}

# Resource outputs for observability
output "resource_group_id" {
  description = "Resource group ID"
  value       = data.azurerm_resource_group.main.id
}

output "system_node_pool_id" {
  description = "System node pool ID for monitoring"
  value       = "${azurerm_kubernetes_cluster.cicd.id}/agentPools/system"
}

output "runner_node_pool_id" {
  description = "Runner node pool ID for monitoring"
  value       = azurerm_kubernetes_cluster_node_pool.runners.id
}
