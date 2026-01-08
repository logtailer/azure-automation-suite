# Artifactory core configuration
component_name               = "artifactory"
location                     = "Central India"
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Container Registry
container_registry_name = "acrnexuscore001"
container_registry_sku  = "Basic"

# Container Resources
container_cpu    = "2.0"
container_memory = "4.0"
nexus_image_tag  = "3-latest"

# Storage Configuration
storage_account_sku = "Standard_LRS"
file_share_quota    = 100

# Health Probe Configuration
liveness_initial_delay  = 300
readiness_initial_delay = 60

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
