variable "resource_group_name" {
  description = "Name of the resource group for this component"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "law-monitoring"
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "application_insights_name" {
  description = "Name of the Application Insights instance"
  type        = string
  default     = "appinsights-monitoring"
}

variable "action_group_name" {
  description = "Name of the monitor action group"
  type        = string
  default     = "alerts-actiongroup"
}

variable "admin_email" {
  description = "Admin email for alerts"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "aks_cluster_id" {
  description = "Resource ID of the AKS cluster to monitor"
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "Resource ID of the storage account to monitor"
  type        = string
  default     = ""
}

variable "grafana_name" {
  description = "Name of the Grafana dashboard"
  type        = string
  default     = "grafana-monitoring"
}

# IDP Integration variables
variable "enable_idp_monitoring" {
  description = "Enable monitoring for IDP (Backstage) resources"
  type        = bool
  default     = false
}

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
