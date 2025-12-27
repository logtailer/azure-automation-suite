
# AKS Cluster Outputs
output "kube_config" {
  description = "Kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.cluster.kube_config_raw
  sensitive   = true
}

output "cluster_name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.cluster.name
}

output "resource_group_name" {
  description = "Resource group for the AKS cluster."
  value       = azurerm_kubernetes_cluster.cluster.resource_group_name
}

# User Node Pool Outputs
output "user_node_pool_id" {
  description = "ID of the user node pool."
  value       = azurerm_kubernetes_cluster_node_pool.user_node_pool.id
}

output "user_node_pool_name" {
  description = "Name of the user node pool."
  value       = azurerm_kubernetes_cluster_node_pool.user_node_pool.name
}

output "user_node_pool_vm_size" {
  description = "VM size of the user node pool."
  value       = azurerm_kubernetes_cluster_node_pool.user_node_pool.vm_size
}

# Security
output "vm_nsg_id" {
  description = "ID of the VM network security group"
  value       = azurerm_network_security_group.vm_nsg.id
}

output "bastion_host_id" {
  description = "ID of the Azure Bastion Host."
  value       = azurerm_bastion_host.aks_bastion.id
}

output "bastion_host_ip" {
  description = "Public IP of the Azure Bastion Host."
  value       = azurerm_public_ip.bastion_public_ip.ip_address
}