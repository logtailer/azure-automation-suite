variable "resource_group_name" {
  description = "Name of the resource group for component resources"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "tfstate_resource_group_name" {
  description = "Name of the resource group for terraform state storage"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Name of the Azure Storage Account for terraform state"
  type        = string
}

variable "component_name" {
  description = "Name of the component (used for container name)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Cost monitoring variables
variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD for cost monitoring"
  type        = number
  default     = 100
}

variable "cost_alert_threshold_1" {
  description = "First cost alert threshold percentage (e.g., 50 for 50%)"
  type        = number
  default     = 50
}

variable "cost_alert_threshold_2" {
  description = "Second cost alert threshold percentage (e.g., 80 for 80%)"
  type        = number
  default     = 80
}

variable "cost_alert_threshold_3" {
  description = "Third cost alert threshold percentage (e.g., 100 for 100%)"
  type        = number
  default     = 100
}

variable "cost_alert_emails" {
  description = "List of email addresses to receive cost alerts"
  type        = list(string)
  default     = []
}

variable "enable_component_budget" {
  description = "Whether to create a separate budget for this specific component"
  type        = bool
  default     = false
}

variable "component_budget_amount" {
  description = "Budget amount for individual component (if enabled)"
  type        = number
  default     = 20
}

# Component-wise budget configuration
variable "component_budgets" {
  description = "Budget configuration for each component type"
  type = map(object({
    amount    = number
    threshold = number
  }))
  default = {
    foundation     = { amount = 5,  threshold = 80 }
    networking     = { amount = 10, threshold = 80 }
    security       = { amount = 3,  threshold = 80 }
    aks           = { amount = 25, threshold = 80 }
    observability = { amount = 5,  threshold = 80 }
    cicd          = { amount = 2,  threshold = 80 }
    idp           = { amount = 5,  threshold = 80 }
  }
}
