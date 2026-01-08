# Nexus Artifactory - Development Environment
resource_group_name = "azure-platform-dev-rg"
location            = "Central India"
environment         = "dev"
component_name      = "artifactory"

# Azure Container Registry for Nexus images
container_registry_name = "acrnexusdev001"

# Backend configuration
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Container resources (Nexus needs more than Backstage)
container_cpu    = "2.0"
container_memory = "4.0"

# Storage configuration
storage_account_sku = "Standard_LRS"
file_share_quota    = 100

# Cost monitoring
enable_component_budget = true
component_budget_amount = 50
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
