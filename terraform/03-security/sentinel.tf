# Azure Sentinel (Microsoft Sentinel) - SIEM Solution
# Requires Log Analytics workspace from observability module

# Get observability outputs from remote state
data "terraform_remote_state" "observability" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "observability"
    key                  = "observability.tfstate"
    use_azuread_auth     = true
  }
}

# Enable Microsoft Sentinel on existing Log Analytics workspace
resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  workspace_resource_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
  workspace_name        = data.terraform_remote_state.observability.outputs.log_analytics_workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

  tags = var.tags
}

# Data connectors for Azure Activity Logs
resource "azurerm_sentinel_data_connector_azure_active_directory" "aad" {
  count                      = var.enable_sentinel_aad_connector ? 1 : 0
  name                       = "aad-connector"
  log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
}

resource "azurerm_sentinel_data_connector_azure_security_center" "asc" {
  count                      = var.enable_sentinel_asc_connector ? 1 : 0
  name                       = "asc-connector"
  log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
}

# Sentinel alert rules for security incidents
resource "azurerm_sentinel_alert_rule_scheduled" "brute_force_attempt" {
  count                      = var.enable_sentinel_alert_rules ? 1 : 0
  name                       = "BruteForceAttempt"
  log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
  display_name               = "Potential Brute Force Attack Detected"
  severity                   = "High"
  enabled                    = true

  query = <<QUERY
SigninLogs
| where ResultType != 0
| where UserPrincipalName !contains "sync"
| summarize FailedAttempts = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 5m)
| where FailedAttempts > 5
QUERY

  query_frequency = "PT5M"
  query_period    = "PT5M"

  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  suppression_enabled  = false
  suppression_duration = "PT5H"
}

resource "azurerm_sentinel_alert_rule_scheduled" "admin_account_created" {
  count                      = var.enable_sentinel_alert_rules ? 1 : 0
  name                       = "AdminAccountCreated"
  log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
  display_name               = "New Admin Account Created"
  severity                   = "Medium"
  enabled                    = true

  query = <<QUERY
AuditLogs
| where OperationName == "Add member to role"
| where TargetResources[0].modifiedProperties[0].newValue contains "Global Administrator"
  or TargetResources[0].modifiedProperties[0].newValue contains "Privileged Role Administrator"
QUERY

  query_frequency = "PT15M"
  query_period    = "PT15M"

  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  suppression_enabled  = false
  suppression_duration = "PT5H"
}
