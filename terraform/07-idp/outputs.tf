# Outputs for Internal Developer Platform (IDP) module
output "backstage_url" {
  description = "URL for accessing Backstage"
  value       = "http://${azurerm_container_group.backstage.fqdn}:7007"
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.backstage.name
}

output "container_registry_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = azurerm_container_registry.backstage.login_server
}

output "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.backstage_db.name
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.backstage_db.fqdn
  sensitive   = true
}

output "container_group_name" {
  description = "Name of the Azure Container Instance"
  value       = azurerm_container_group.backstage.name
}

output "managed_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.backstage.id
}

output "application_name" {
  description = "Display name of the Azure AD application"
  value       = azuread_application.platform.display_name
}

output "application_id" {
  description = "Application (client) ID of the Azure AD application"
  value       = azuread_application.platform.client_id
}

output "tenant_id" {
  description = "Azure AD tenant ID"
  value       = data.azuread_client_config.current.tenant_id
}

output "service_principal_id" {
  description = "Object ID of the service principal"
  value       = azuread_service_principal.platform.object_id
}

output "client_secret" {
  description = "Client secret for the application"
  value       = azuread_application_password.platform.value
  sensitive   = true
}

output "admin_group_name" {
  description = "Name of the admin group"
  value       = azuread_group.platform_admins.display_name
}

output "admin_group_id" {
  description = "Object ID of the admin group"
  value       = azuread_group.platform_admins.object_id
}

output "developer_group_name" {
  description = "Name of the developer group"
  value       = azuread_group.platform_developers.display_name
}

output "developer_group_id" {
  description = "Object ID of the developer group"
  value       = azuread_group.platform_developers.object_id
}

output "viewer_group_name" {
  description = "Name of the viewer group"
  value       = azuread_group.platform_viewers.display_name
}

output "viewer_group_id" {
  description = "Object ID of the viewer group"
  value       = azuread_group.platform_viewers.object_id
}

output "acr_login_server" {
  description = "Login server URL for ACR (for docker login)"
  value       = azurerm_container_registry.backstage.login_server
}

output "managed_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.backstage.client_id
}

output "container_fqdn" {
  description = "Fully qualified domain name of the container instance"
  value       = azurerm_container_group.backstage.fqdn
}

output "container_ip_address" {
  description = "IP address of the container instance"
  value       = azurerm_container_group.backstage.ip_address
}

output "resource_group_id" {
  description = "ID of the resource group containing IDP resources"
  value       = data.azurerm_resource_group.main.id
}

output "resource_group_name_output" {
  description = "Name of the resource group (for cross-module reference)"
  value       = data.azurerm_resource_group.main.name
}
