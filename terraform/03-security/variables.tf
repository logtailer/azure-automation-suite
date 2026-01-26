variable "resource_group_name" {
  description = "Name of the resource group for this component"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "key_vault_sku" {
  description = "SKU name for the Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted items"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Managed Identity Configuration
variable "enable_aks_identity" {
  description = "Create managed identity for AKS workloads"
  type        = bool
  default     = true
}

variable "enable_app_identity" {
  description = "Create managed identity for application workloads"
  type        = bool
  default     = true
}

variable "enable_devops_identity" {
  description = "Create managed identity for DevOps automation"
  type        = bool
  default     = true
}

variable "enable_monitoring_identity" {
  description = "Create managed identity for monitoring services"
  type        = bool
  default     = true
}

variable "custom_role_assignments" {
  description = "Map of custom role assignments for specific workloads"
  type = map(object({
    scope        = string
    role         = string
    principal_id = string
  }))
  default = {}
}

# Network Security Configuration
variable "enable_network_security" {
  description = "Enable network security group for security resources"
  type        = bool
  default     = true
}

variable "enable_kv_network_restriction" {
  description = "Enable network restrictions on Key Vault"
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for Key Vault access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default allows all, should be restricted in production
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint (required if enable_private_endpoint is true)"
  type        = string
  default     = ""
}

variable "vnet_id" {
  description = "VNet ID for private DNS zone link (required if enable_private_endpoint is true)"
  type        = string
  default     = ""
}

# Resource Lock Configuration
variable "enable_resource_locks" {
  description = "Enable resource locks on critical resources"
  type        = bool
  default     = true
}

variable "enable_rg_lock" {
  description = "Enable resource lock on security resource group"
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Level of resource lock (CanNotDelete or ReadOnly)"
  type        = string
  default     = "CanNotDelete"
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "Lock level must be either CanNotDelete or ReadOnly"
  }
}

# Azure Policy Configuration
variable "enable_tag_policy" {
  description = "Enable policy to require tags on resources"
  type        = bool
  default     = true
}

variable "enable_https_policy" {
  description = "Enable policy to require HTTPS for storage"
  type        = bool
  default     = true
}

variable "enable_kv_purge_policy" {
  description = "Enable policy to audit Key Vaults without purge protection"
  type        = bool
  default     = true
}

variable "enable_defender_policy" {
  description = "Enable policy to require Azure Defender for Key Vault"
  type        = bool
  default     = false
}

variable "enable_kv_public_block_policy" {
  description = "Enable policy to block public network access to Key Vault"
  type        = bool
  default     = false
}

# Audit Logging Configuration
variable "enable_audit_logging" {
  description = "Enable audit logging for Key Vault"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostic logs"
  type        = string
  default     = ""
}

variable "enable_kv_alerts" {
  description = "Enable monitoring alerts for Key Vault"
  type        = bool
  default     = true
}

variable "action_group_id" {
  description = "Action group ID for alert notifications"
  type        = string
  default     = ""
}

# Terraform state configuration (for cross-module references)
variable "tfstate_resource_group_name" {
  description = "Name of the resource group for terraform state storage"
  type        = string
  default     = "terraform-state-rg"
}

variable "tfstate_storage_account_name" {
  description = "Name of the Azure Storage Account for terraform state"
  type        = string
  default     = "sumittfstatestorage"
}

# Cost monitoring variables
variable "enable_component_budget" {
  description = "Whether to create a budget for this component"
  type        = bool
  default     = true
}

variable "component_budget_amount" {
  description = "Budget amount for this component in USD"
  type        = number
  default     = 10
}

variable "cost_alert_threshold" {
  description = "Cost alert threshold percentage"
  type        = number
  default     = 80
}

variable "cost_alert_emails" {
  description = "List of email addresses for cost alerts"
  type        = list(string)
  default     = []
}

# Enhanced Key Vault configuration
variable "default_network_action" {
  description = "Default action for Key Vault network ACLs"
  type        = string
  default     = "Allow"
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "purge_soft_delete_on_destroy" {
  description = "Purge soft delete on destroy"
  type        = bool
  default     = false
}

variable "recover_soft_deleted_key_vaults" {
  description = "Recover soft deleted key vaults"
  type        = bool
  default     = true
}

variable "component_name" {
  description = "Name of the component"
  type        = string
  default     = "security"
}

# Terraform state configuration
variable "tfstate_resource_group_name" {
  description = "Resource group containing Terraform state"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Storage account for Terraform state"
  type        = string
}

# Sentinel configuration
variable "enable_sentinel_aad_connector" {
  description = "Enable Azure Active Directory data connector for Sentinel"
  type        = bool
  default     = true
}

variable "enable_sentinel_asc_connector" {
  description = "Enable Azure Security Center data connector for Sentinel"
  type        = bool
  default     = true
}

variable "enable_sentinel_alert_rules" {
  description = "Enable pre-configured Sentinel alert rules"
  type        = bool
  default     = true
}

# Defender for Cloud configuration
variable "defender_tier_servers" {
  description = "Defender tier for Virtual Machines (Free or Standard)"
  type        = string
  default     = "Standard"
}

variable "defender_tier_app_service" {
  description = "Defender tier for App Services"
  type        = string
  default     = "Standard"
}

variable "defender_tier_storage" {
  description = "Defender tier for Storage Accounts"
  type        = string
  default     = "Standard"
}

variable "defender_tier_containers" {
  description = "Defender tier for Containers (AKS)"
  type        = string
  default     = "Standard"
}

variable "defender_tier_key_vault" {
  description = "Defender tier for Key Vault"
  type        = string
  default     = "Standard"
}

variable "defender_tier_sql" {
  description = "Defender tier for SQL Databases"
  type        = string
  default     = "Standard"
}

variable "defender_tier_sql_vms" {
  description = "Defender tier for SQL Server VMs"
  type        = string
  default     = "Standard"
}

variable "security_contact_email" {
  description = "Email address for security alerts"
  type        = string
}

variable "security_contact_phone" {
  description = "Phone number for security contact"
  type        = string
  default     = ""
}

variable "alert_notifications_enabled" {
  description = "Enable alert notifications to security contact"
  type        = bool
  default     = true
}

variable "alerts_to_admins_enabled" {
  description = "Send alerts to subscription admins"
  type        = bool
  default     = true
}

variable "auto_provision_log_analytics" {
  description = "Auto-provision Log Analytics agent on VMs"
  type        = bool
  default     = true
}

# Azure Firewall configuration
variable "enable_firewall" {
  description = "Enable Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_sku_name" {
  description = "SKU name for Azure Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "SKU tier for Azure Firewall (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "firewall_intrusion_detection_mode" {
  description = "Intrusion detection mode (Off, Alert, Deny)"
  type        = string
  default     = "Alert"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
