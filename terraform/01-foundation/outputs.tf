output "component_resource_group_name" {
  description = "Name of the component resource group"
  value       = azurerm_resource_group.component.name
}

output "component_resource_group_id" {
  description = "ID of the component resource group"
  value       = azurerm_resource_group.component.id
}

output "tfstate_resource_group_name" {
  description = "Name of the terraform state resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "tfstate_storage_account_name" {
  description = "Name of the terraform state storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "tfstate_storage_account_id" {
  description = "ID of the terraform state storage account"
  value       = azurerm_storage_account.tfstate.id
}

output "component_container_name" {
  description = "Name of the component's state container"
  value       = azurerm_storage_container.component_state.name
}

# Cost monitoring outputs
output "platform_budget_id" {
  description = "ID of the platform-wide budget"
  value       = azurerm_consumption_budget_subscription.platform_budget.id
}

output "budget_amount" {
  description = "Monthly budget amount configured"
  value       = var.monthly_budget_amount
}

output "cost_alert_emails" {
  description = "Email addresses configured for cost alerts"
  value       = var.cost_alert_emails
  sensitive   = true
}

output "anomaly_detection_enabled" {
  description = "Whether anomaly detection is enabled for this component"
  value       = var.component_name == "foundation"
}