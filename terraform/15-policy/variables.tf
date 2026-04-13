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
