location            = "Central India"
resource_group_name = "artifactory-dev-rg"
environment         = "dev"
component_name      = "artifactory"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Container — minimal resources
container_registry_name = "acrdevplatform001"
container_registry_sku  = "Basic"
container_cpu           = "0.5"
container_memory        = "0.5"
nexus_image_tag         = "3.70.1"

# Storage — LRS, small quota
storage_account_sku = "Standard_LRS"
file_share_quota    = 50

# Health check delays
liveness_initial_delay  = 120
readiness_initial_delay = 90

# Budget
enable_component_budget = false
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["anandsumit2000@gmail.com"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
