output "container_registry_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}

output "container_registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_admin_username" {
  description = "Admin username for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Admin password for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "build_artifacts_storage_id" {
  description = "ID of the build artifacts storage account"
  value       = azurerm_storage_account.build_artifacts.id
}

output "build_artifacts_storage_name" {
  description = "Name of the build artifacts storage account"
  value       = azurerm_storage_account.build_artifacts.name
}

output "build_agents_vmss_id" {
  description = "ID of the build agents VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.build_agents.id
}
