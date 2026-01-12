# Microsoft Defender for Cloud (formerly Azure Security Center)
# Provides threat protection across Azure resources

# Get current subscription
data "azurerm_subscription" "current" {}

# Enable Defender for Servers
resource "azurerm_security_center_subscription_pricing" "servers" {
  tier          = var.defender_tier_servers
  resource_type = "VirtualMachines"
}

# Enable Defender for App Service
resource "azurerm_security_center_subscription_pricing" "app_service" {
  tier          = var.defender_tier_app_service
  resource_type = "AppServices"
}

# Enable Defender for Storage
resource "azurerm_security_center_subscription_pricing" "storage" {
  tier          = var.defender_tier_storage
  resource_type = "StorageAccounts"
}

# Enable Defender for Containers (AKS)
resource "azurerm_security_center_subscription_pricing" "containers" {
  tier          = var.defender_tier_containers
  resource_type = "Containers"
}

# Enable Defender for Key Vault
resource "azurerm_security_center_subscription_pricing" "key_vault" {
  tier          = var.defender_tier_key_vault
  resource_type = "KeyVaults"
}

# Enable Defender for SQL Databases
resource "azurerm_security_center_subscription_pricing" "sql_servers" {
  tier          = var.defender_tier_sql
  resource_type = "SqlServers"
}

# Enable Defender for SQL Server VMs
resource "azurerm_security_center_subscription_pricing" "sql_server_vms" {
  tier          = var.defender_tier_sql_vms
  resource_type = "SqlServerVirtualMachines"
}

# Security Center Contact
resource "azurerm_security_center_contact" "main" {
  email = var.security_contact_email
  phone = var.security_contact_phone
  alert_notifications = var.alert_notifications_enabled
  alerts_to_admins    = var.alerts_to_admins_enabled
}

# Auto-provisioning of Log Analytics agent
resource "azurerm_security_center_auto_provisioning" "log_analytics" {
  auto_provision = var.auto_provision_log_analytics ? "On" : "Off"
}

# Defender for Cloud Workspace configuration
resource "azurerm_security_center_workspace" "main" {
  count        = var.auto_provision_log_analytics ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
}
