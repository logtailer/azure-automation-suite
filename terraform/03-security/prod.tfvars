# Production environment security configuration
component_name      = "security"
resource_group_name = "rg-security-prod"
location            = "Central India"

key_vault_name              = "kv-platform-prod-001"
enabled_for_disk_encryption = true
enabled_for_deployment      = true
soft_delete_retention_days  = 90
purge_protection_enabled    = true
sku_name                    = "premium"
enable_rbac_authorization   = true
default_network_action      = "Deny"
allowed_ip_ranges           = []

enable_aks_identity        = true
enable_app_identity        = true
enable_devops_identity     = true
enable_monitoring_identity = true

enable_network_security       = true
enable_kv_network_restriction = true
enable_private_endpoint       = true
subnet_id                     = ""
vnet_id                       = ""

enable_resource_locks = true
enable_rg_lock        = true
lock_level            = "CanNotDelete"

enable_tag_policy             = true
enable_https_policy           = true
enable_kv_purge_policy        = true
enable_defender_policy        = true
enable_kv_public_block_policy = true

enable_audit_logging       = true
enable_kv_alerts           = true
log_analytics_workspace_id = ""
action_group_id            = ""

enable_component_budget = true
component_budget_amount = 50
cost_alert_threshold    = 75
cost_alert_emails       = ["platform-team@example.com", "security@example.com"]

enable_sentinel_aad_connector = true
enable_sentinel_asc_connector = true
enable_sentinel_alert_rules   = true

defender_tier_servers     = "Standard"
defender_tier_app_service = "Standard"
defender_tier_storage     = "Standard"
defender_tier_containers  = "Standard"
defender_tier_key_vault   = "Standard"
defender_tier_sql         = "Standard"
defender_tier_sql_vms     = "Standard"

security_contact_email       = "security@example.com"
alert_notifications_enabled  = true
alerts_to_admins_enabled     = true
auto_provision_log_analytics = true

enable_firewall                   = true
firewall_sku_tier                 = "Premium"
firewall_intrusion_detection_mode = "Deny"
environment                       = "prod"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
