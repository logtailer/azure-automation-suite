# Required variables
variable "resource_group_name" {
  description = "Name of the resource group for this component"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "component_name" {
  description = "Name of the component (used for naming)"
  type        = string
  default     = "artifactory"
}

# Backend state variables
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

# Container Registry
variable "container_registry_name" {
  description = "Name of the Azure Container Registry for Nexus images"
  type        = string
}

variable "container_registry_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}

# Container Instance
variable "container_cpu" {
  description = "CPU cores for Nexus container (in cores)"
  type        = string
  default     = "2.0"
}

variable "container_memory" {
  description = "Memory for Nexus container (in GB)"
  type        = string
  default     = "4.0"
}

variable "nexus_image_tag" {
  description = "Nexus Docker image tag"
  type        = string
  default     = "3-latest"
}

# Storage Account
variable "storage_account_sku" {
  description = "SKU for Storage Account"
  type        = string
  default     = "Standard_LRS"
}

variable "file_share_quota" {
  description = "Quota for Azure Files share in GB"
  type        = number
  default     = 100
}

# Health Probe Configuration
variable "liveness_initial_delay" {
  description = "Initial delay for liveness probe in seconds"
  type        = number
  default     = 300
}

variable "readiness_initial_delay" {
  description = "Initial delay for readiness probe in seconds"
  type        = number
  default     = 60
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Cost Monitoring
variable "enable_component_budget" {
  description = "Whether to create a budget for this component"
  type        = bool
  default     = false
}

variable "component_budget_amount" {
  description = "Budget amount for this component in USD"
  type        = number
  default     = 50
}

variable "cost_alert_threshold" {
  description = "Cost alert threshold percentage (e.g., 80 for 80%)"
  type        = number
  default     = 80
}

variable "cost_alert_emails" {
  description = "List of email addresses to receive cost alerts"
  type        = list(string)
  default     = []
}
