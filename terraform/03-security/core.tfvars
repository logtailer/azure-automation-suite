# Security module configuration
component_name      = "security"
resource_group_name = "rg-security"
location            = "Central India"

# Key Vault Configuration
key_vault_name                = "kv-platform-security-001"
enabled_for_disk_encryption   = true
enabled_for_deployment        = true
soft_delete_retention_days    = 90
purge_protection_enabled      = true
sku_name                      = "standard"
enable_rbac_authorization     = true
default_network_action        = "Deny" # Restrict by default
allowed_ip_ranges             = []     # Add your IPs

# Identity Configuration
enable_aks_identity        = true
enable_app_identity        = true
enable_devops_identity     = true
enable_monitoring_identity = true

# Network Security
enable_network_security         = true
enable_kv_network_restriction   = true
enable_private_endpoint         = false # Enable when VNet is available
subnet_id                       = ""
vnet_id                         = ""

# Governance
enable_resource_locks = true
enable_rg_lock        = false
lock_level            = "CanNotDelete"

# Azure Policy
enable_tag_policy             = true
enable_https_policy           = true
enable_kv_purge_policy        = true
enable_defender_policy        = false
enable_kv_public_block_policy = false

# Audit Logging
enable_audit_logging = true
enable_kv_alerts     = true
log_analytics_workspace_id = "" # Set from observability module
action_group_id            = "" # Set from observability module

# Cost Monitoring
enable_component_budget = true
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]

tags = {
  Environment = "Production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}

# Terraform state
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Sentinel configuration
enable_sentinel_aad_connector = true
enable_sentinel_asc_connector = true
enable_sentinel_alert_rules   = true

# Defender for Cloud
defender_tier_servers     = "Standard"
defender_tier_app_service = "Standard"
defender_tier_storage     = "Standard"
defender_tier_containers  = "Standard"
defender_tier_key_vault   = "Standard"
defender_tier_sql         = "Free"
defender_tier_sql_vms     = "Free"

security_contact_email         = "security@example.com"
alert_notifications_enabled    = true
alerts_to_admins_enabled       = true
auto_provision_log_analytics   = true

# Azure Firewall
enable_firewall                  = true
firewall_sku_tier                = "Standard"
firewall_intrusion_detection_mode = "Alert"
environment                      = "dev"
