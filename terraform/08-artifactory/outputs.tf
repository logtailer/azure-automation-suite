# URL outputs
output "nexus_url" {
  description = "URL for accessing Nexus repository"
  value       = "http://${azurerm_container_group.nexus.fqdn}:8081"
}

output "container_fqdn" {
  description = "Fully qualified domain name of the container instance"
  value       = azurerm_container_group.nexus.fqdn
}

output "container_ip_address" {
  description = "IP address of the container instance"
  value       = azurerm_container_group.nexus.ip_address
}

# Resource IDs for observability integration
output "container_group_name" {
  description = "ACI resource ID (for monitoring alerts)"
  value       = azurerm_container_group.nexus.id
}

output "resource_group_id" {
  description = "Resource group ID (for Grafana RBAC)"
  value       = data.azurerm_resource_group.main.id
}

output "resource_group_name_output" {
  description = "Name of the resource group (for cross-module reference)"
  value       = data.azurerm_resource_group.main.name
}

output "storage_account_id" {
  description = "Storage account ID (for monitoring)"
  value       = azurerm_storage_account.nexus_data.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.nexus_data.name
}

output "file_share_name" {
  description = "Azure Files share name"
  value       = azurerm_storage_share.nexus_data.name
}

# Container Registry outputs
output "container_registry_name" {
  description = "Container Registry resource ID"
  value       = azurerm_container_registry.nexus.id
}

output "container_registry_login_server" {
  description = "Container Registry login server"
  value       = azurerm_container_registry.nexus.login_server
}

# Identity outputs
output "managed_identity_id" {
  description = "Managed identity resource ID"
  value       = azurerm_user_assigned_identity.nexus.id
}

output "managed_identity_client_id" {
  description = "Managed identity client ID"
  value       = azurerm_user_assigned_identity.nexus.client_id
}

# Admin password location
output "nexus_admin_password_location" {
  description = "Instructions to retrieve Nexus admin password"
  value       = "Run: az container logs --name ${azurerm_container_group.nexus.name} --resource-group ${data.azurerm_resource_group.main.name} 2>&1 | grep -i password"
}
