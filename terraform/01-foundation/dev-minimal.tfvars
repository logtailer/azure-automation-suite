location                     = "Central India"
resource_group_name          = "azure-platform-dev-rg"
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"
component_name               = "foundation"
environment                  = "dev"

# Budget — low limit for weekly test sessions
monthly_budget_amount   = 20
cost_alert_threshold_1  = 50
cost_alert_threshold_2  = 80
cost_alert_threshold_3  = 100
cost_alert_emails       = ["anandsumit2000@gmail.com"]
enable_component_budget = false

# ACR — Basic SKU, no geo-replication
enable_acr           = true
acr_name             = "acrdevplatform001"
acr_sku              = "Basic"
acr_private_only     = false
acr_geo_replications = []
acr_retention_days   = 7
acr_content_trust    = false

# Storage — LRS only
enable_platform_storage       = true
platform_storage_account_name = "stdevplatform001"
platform_storage_replication  = "LRS"

# Disable all expensive optional features
enable_service_bus      = false
enable_front_door       = false
enable_event_grid       = false
enable_logic_app        = false
enable_apim             = false
enable_notification_hub = false
enable_app_config       = false

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
