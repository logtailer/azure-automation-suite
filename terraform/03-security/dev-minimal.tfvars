location            = "Central India"
resource_group_name = "azure-platform-dev-rg"
environment         = "dev"
component_name      = "security"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Key Vault — standard SKU, no purge protection for easy teardown
key_vault_name               = "kv-azplatdev-001"
key_vault_sku                = "standard"
soft_delete_retention_days   = 7
purge_protection_enabled     = false
purge_soft_delete_on_destroy = true
default_network_action       = "Allow"
enable_rbac_authorization    = true

# Managed identities — keep enabled (free)
enable_aks_identity        = true
enable_app_identity        = true
enable_devops_identity     = false
enable_monitoring_identity = true

# Defender — Free tier only (paid plans are expensive)
defender_tier_servers     = "Free"
defender_tier_app_service = "Free"
defender_tier_storage     = "Free"
defender_tier_containers  = "Free"
defender_tier_key_vault   = "Free"
defender_tier_sql         = "Free"
defender_tier_sql_vms     = "Free"

# Disable Sentinel (expensive)
enable_sentinel_aad_connector = false
enable_sentinel_asc_connector = false
enable_sentinel_alert_rules   = false

# Disable expensive / complex features
enable_firewall               = false
enable_resource_locks         = false
enable_rg_lock                = false
enable_kv_network_restriction = false
enable_private_endpoint       = false
enable_kv_private_endpoint    = false
enable_jit_access             = false
enable_pim_group              = false
enable_pim_alerts             = false
enable_break_glass            = false
enable_customer_managed_key   = false
enable_workload_identity      = false
enable_tls_certificate        = false
enable_tag_policy             = false
enable_https_policy           = false
enable_kv_purge_policy        = false
enable_defender_policy        = false
enable_kv_public_block_policy = false
enable_mfa_alerts             = false

# Keep audit logging (Log Analytics is cheap)
enable_audit_logging       = true
log_analytics_workspace_id = ""

# Security contact
security_contact_email       = "anandsumit2000@gmail.com"
security_contact_phone       = ""
alert_notifications_enabled  = true
alerts_to_admins_enabled     = true
auto_provision_log_analytics = false

# Budget
enable_component_budget = false
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["anandsumit2000@gmail.com"]

# SSH key placeholder (required variable)
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0placeholder dev-minimal"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
