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
