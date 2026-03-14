variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group"
  type        = string
}

variable "vault_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "platform-backup-vault"
}

variable "vault_sku" {
  description = "SKU for the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "backup_policy_name" {
  description = "Name of the backup policy to apply"
  type        = string
  default     = "DefaultPolicy"
}

variable "enable_cross_region_restore" {
  description = "Enable cross-region restore for the Recovery Services vault"
  type        = bool
  default     = false
}
