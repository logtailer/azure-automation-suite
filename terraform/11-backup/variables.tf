variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group"
  type        = string
}

variable "vault_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "platform-backup-vault"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
