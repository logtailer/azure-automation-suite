# Dev environment security configuration
component_name      = "security"
resource_group_name = "rg-security-dev"
location            = "Central India"

key_vault_name              = "kv-platform-dev-001"
enabled_for_disk_encryption = true
enabled_for_deployment      = true
soft_delete_retention_days  = 90
purge_protection_enabled    = true
sku_name                    = "standard"
enable_rbac_authorization   = true
default_network_action      = "Allow"
allowed_ip_ranges           = []

enable_aks_identity        = true
enable_app_identity        = true
enable_devops_identity     = true
enable_monitoring_identity = true

enable_network_security       = false
enable_kv_network_restriction = false
enable_private_endpoint       = false
subnet_id                     = ""
vnet_id                       = ""

enable_resource_locks = false
enable_rg_lock        = false
lock_level            = "CanNotDelete"

enable_tag_policy             = true
enable_https_policy           = true
enable_kv_purge_policy        = true
enable_defender_policy        = false
enable_kv_public_block_policy = false

enable_audit_logging       = true
enable_kv_alerts           = false
log_analytics_workspace_id = ""
action_group_id            = ""

enable_component_budget = true
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]

enable_sentinel_aad_connector = false
enable_sentinel_asc_connector = false
enable_sentinel_alert_rules   = false

defender_tier_servers     = "Free"
defender_tier_app_service = "Free"
defender_tier_storage     = "Free"
defender_tier_containers  = "Free"
defender_tier_key_vault   = "Free"
defender_tier_sql         = "Free"
defender_tier_sql_vms     = "Free"

security_contact_email       = "security@example.com"
alert_notifications_enabled  = false
alerts_to_admins_enabled     = false
auto_provision_log_analytics = false

enable_firewall                   = false
firewall_sku_tier                 = "Standard"
firewall_intrusion_detection_mode = "Off"
environment                       = "dev"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
