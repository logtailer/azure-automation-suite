# Outputs for Internal Developer Platform (IDP) module
output "backstage_namespace" {
  description = "Kubernetes namespace for Backstage"
  value       = kubernetes_namespace.backstage.metadata[0].name
}

output "backstage_service_url" {
  description = "URL for accessing Backstage service"
  value       = "http://backstage.platform.local"
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.backstage_db.fqdn
  sensitive   = true
}

output "backstage_helm_release_status" {
  description = "Status of the Backstage Helm release"
  value       = helm_release.backstage.status
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

output "admin_group_id" {
  description = "Object ID of the admin group"
  value       = azuread_group.platform_admins.object_id
}

output "developer_group_id" {
  description = "Object ID of the developer group"
  value       = azuread_group.platform_developers.object_id
}

output "viewer_group_id" {
  description = "Object ID of the viewer group"
  value       = azuread_group.platform_viewers.object_id
}
