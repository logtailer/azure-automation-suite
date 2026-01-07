output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "application_insights_id" {
  description = "ID of the Application Insights instance"
  value       = azurerm_application_insights.main.id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "action_group_id" {
  description = "ID of the monitor action group"
  value       = azurerm_monitor_action_group.main.id
}

output "grafana_url" {
  description = "URL for accessing Grafana dashboard"
  value       = azurerm_dashboard_grafana.main.endpoint
}

output "grafana_id" {
  description = "Resource ID of the Grafana dashboard"
  value       = azurerm_dashboard_grafana.main.id
}
