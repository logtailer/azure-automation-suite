# AKS cluster outputs — cluster is provisioned in 04-aks module
# These outputs reference remote state rather than local resources
output "resource_group_name" {
  description = "Resource group for GitHub runner infrastructure"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Resource group ID for GitHub runner infrastructure"
  value       = azurerm_resource_group.this.id
}
