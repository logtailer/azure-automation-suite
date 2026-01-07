output "key_vault_id" {
  description = "ID of the Azure Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.main.name
}

output "ssh_public_key_secret_id" {
  description = "ID of the SSH public key secret in Key Vault"
  value       = azurerm_key_vault_secret.ssh_public_key.id
}

# Managed Identity Outputs
output "aks_workload_identity_id" {
  description = "ID of the AKS workload managed identity"
  value       = var.enable_aks_identity ? azurerm_user_assigned_identity.aks_workload[0].id : null
}

output "aks_workload_identity_client_id" {
  description = "Client ID of the AKS workload managed identity"
  value       = var.enable_aks_identity ? azurerm_user_assigned_identity.aks_workload[0].client_id : null
}

output "app_workload_identity_id" {
  description = "ID of the application workload managed identity"
  value       = var.enable_app_identity ? azurerm_user_assigned_identity.app_workload[0].id : null
}

output "devops_identity_id" {
  description = "ID of the DevOps automation managed identity"
  value       = var.enable_devops_identity ? azurerm_user_assigned_identity.devops[0].id : null
}

output "monitoring_identity_id" {
  description = "ID of the monitoring managed identity"
  value       = var.enable_monitoring_identity ? azurerm_user_assigned_identity.monitoring[0].id : null
}

# Network Security Outputs
output "security_nsg_id" {
  description = "ID of the security network security group"
  value       = var.enable_network_security ? azurerm_network_security_group.security[0].id : null
}

output "keyvault_private_endpoint_ip" {
  description = "Private IP address of Key Vault private endpoint"
  value       = var.enable_private_endpoint && var.subnet_id != "" ? azurerm_private_endpoint.keyvault[0].private_service_connection[0].private_ip_address : null
}
