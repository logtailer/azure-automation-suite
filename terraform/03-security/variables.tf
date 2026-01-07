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
  default     = 7
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
