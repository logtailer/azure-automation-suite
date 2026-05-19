variable "enforce_policies" {
  description = "Set to true to enforce policies (false = audit only)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "assign_at_management_group" {
  description = "Assign the policy set at the management group level instead of subscription"
  type        = bool
  default     = false
}

variable "management_group_id" {
  description = "Management group ID to assign policies to when assign_at_management_group is true"
  type        = string
  default     = ""
}

variable "non_compliance_message" {
  description = "Custom non-compliance message shown when a resource violates a policy"
  type        = string
  default     = ""
}

variable "create_dev_sku_exemption" {
  description = "Create a policy exemption for a development VM with non-standard SKU"
  type        = bool
  default     = false
}

variable "dev_vm_resource_id" {
  description = "Resource ID of the development VM to exempt from VM SKU policy"
  type        = string
  default     = ""
}

variable "dev_exemption_expiry" {
  description = "Expiry date for the dev VM SKU exemption (RFC3339)"
  type        = string
  default     = "2026-12-31T00:00:00Z"
}

variable "dev_exemption_ticket_ref" {
  description = "Ticket reference for the dev VM SKU exemption approval"
  type        = string
  default     = ""
}

variable "create_legacy_rg_exemption" {
  description = "Create a policy exemption for a legacy resource group migrating to new tagging"
  type        = bool
  default     = false
}

variable "legacy_resource_group_id" {
  description = "Resource group resource ID to exempt from tagging policy"
  type        = string
  default     = ""
}

variable "legacy_exemption_expiry" {
  description = "Expiry date for the legacy RG tagging exemption (RFC3339)"
  type        = string
  default     = "2026-09-30T00:00:00Z"
}
