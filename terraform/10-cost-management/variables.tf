variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group"
  type        = string
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
  default     = 1000
}

variable "rg_budget_amount" {
  description = "Resource group budget amount in USD"
  type        = number
  default     = 500
}

variable "alert_email" {
  description = "Email address for budget alerts"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be a valid email address."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
