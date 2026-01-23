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
