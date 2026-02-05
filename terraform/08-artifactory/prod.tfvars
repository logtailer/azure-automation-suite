# Nexus Artifactory - Production Environment
resource_group_name = "azure-platform-prod-rg"
location            = "Central India"
environment         = "prod"
component_name      = "artifactory"

container_registry_name = "acrnexusprod001"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

container_cpu    = "4.0"
container_memory = "8.0"

storage_account_sku = "Standard_ZRS"
file_share_quota    = 500

enable_component_budget = true
component_budget_amount = 200
cost_alert_threshold    = 75
cost_alert_emails       = ["platform-team@example.com", "oncall@example.com"]

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
