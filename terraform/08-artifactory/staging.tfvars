# Nexus Artifactory - Staging Environment
resource_group_name = "azure-platform-staging-rg"
location            = "Central India"
environment         = "staging"
component_name      = "artifactory"

container_registry_name = "acrnexusstaging001"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

container_cpu    = "2.0"
container_memory = "4.0"

storage_account_sku = "Standard_LRS"
file_share_quota    = 200

enable_component_budget = true
component_budget_amount = 100
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
