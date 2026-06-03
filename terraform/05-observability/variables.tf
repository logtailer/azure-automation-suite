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

# Prometheus variables
variable "enable_prometheus_metrics" {
  description = "Enable Azure Monitor Workspace for Prometheus-compatible metrics"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
  default     = "production"
}

# Component identification
variable "component_name" {
  description = "Name of the component (used for naming)"
  type        = string
  default     = "observability"
}

# Cost monitoring variables
variable "enable_component_budget" {
  description = "Whether to create a budget for this component"
  type        = bool
  default     = false
}

variable "component_budget_amount" {
  description = "Budget amount for this component in USD"
  type        = number
  default     = 20
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

# PagerDuty/OpsGenie integration
variable "enable_pagerduty_integration" {
  description = "Enable PagerDuty integration for alerts"
  type        = bool
  default     = false
}

variable "pagerduty_webhook_url" {
  description = "PagerDuty webhook URL for alert notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_opsgenie_integration" {
  description = "Enable OpsGenie integration for alerts"
  type        = bool
  default     = false
}

variable "opsgenie_webhook_url" {
  description = "OpsGenie webhook URL for alert notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_audit_workspace" {
  description = "Create a dedicated Log Analytics workspace for audit logs"
  type        = bool
  default     = false
}

variable "audit_log_retention_days" {
  description = "Retention in days for the audit Log Analytics workspace"
  type        = number
  default     = 365
}

variable "enable_data_collection_rule" {
  description = "Create a data collection rule for platform-wide log aggregation"
  type        = bool
  default     = false
}

variable "alert_window_size" {
  description = "Window size for metric alert evaluation (ISO 8601 duration)"
  type        = string
  default     = "PT15M"
}

variable "alert_evaluation_frequency" {
  description = "How often metric alerts are evaluated (ISO 8601 duration)"
  type        = string
  default     = "PT5M"
}

variable "critical_alert_emails" {
  description = "Map of name => email address for critical alert action group receivers"
  type        = map(string)
  default     = {}
}

variable "warning_alert_emails" {
  description = "Map of name => email address for warning alert action group receivers"
  type        = map(string)
  default     = {}
}

variable "enable_cost_budget" {
  description = "Create an Azure consumption budget with 80%/100%/110% threshold alerts"
  type        = bool
  default     = false
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD for the subscription cost alert"
  type        = number
  default     = 1000
}

variable "enable_otel_collector" {
  description = "Create an Azure Monitor data collection endpoint and rule for OpenTelemetry"
  type        = bool
  default     = false
}

variable "enable_app_insights" {
  description = "Deploy Application Insights workspace-based resource for APM"
  type        = bool
  default     = false
}

variable "app_insights_retention_days" {
  description = "Data retention in days for Application Insights (30–730)"
  type        = number
  default     = 90
}

variable "app_insights_sampling_percentage" {
  description = "Adaptive sampling percentage for Application Insights (0–100)"
  type        = number
  default     = 100
}

variable "enable_synthetic_monitor" {
  description = "Create an Application Insights web test for synthetic availability monitoring"
  type        = bool
  default     = false
}

variable "synthetic_monitor_url" {
  description = "URL to ping for the synthetic availability monitor"
  type        = string
  default     = "https://api.platform.example.com/health"
}

variable "enable_network_alerts" {
  description = "Enable metric alerts for VNet dropped packets and Application Gateway unhealthy hosts"
  type        = bool
  default     = false
}

variable "vnet_resource_id" {
  description = "Resource ID of the VNet to monitor for dropped packets"
  type        = string
  default     = ""
}

variable "appgw_resource_id" {
  description = "Resource ID of the Application Gateway to monitor for unhealthy backend hosts"
  type        = string
  default     = ""
}

variable "enable_aks_alerts" {
  description = "Enable metric alerts for AKS node CPU, memory, and failed pods"
  type        = bool
  default     = false
}

variable "aks_cpu_alert_threshold" {
  description = "CPU utilisation percentage threshold for AKS node alert"
  type        = number
  default     = 80
}

variable "aks_memory_alert_threshold" {
  description = "Memory working-set percentage threshold for AKS node alert"
  type        = number
  default     = 80
}

variable "enable_slo_alerts" {
  description = "Enable SLO-based error-budget burn and p99 latency alerts"
  type        = bool
  default     = false
}

variable "slo_error_rate_threshold" {
  description = "Error rate fraction (0–1) that triggers the fast-burn alert"
  type        = number
  default     = 0.01
}

variable "slo_latency_p99_ms" {
  description = "p99 latency threshold in milliseconds for the latency SLO alert"
  type        = number
  default     = 500
}

variable "enable_kv_diagnostics" {
  description = "Send Key Vault audit logs to Log Analytics"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault to capture diagnostic logs from"
  type        = string
  default     = ""
}

variable "enable_storage_diagnostics" {
  description = "Send storage account blob operation logs to Log Analytics"
  type        = bool
  default     = false
}

variable "enable_apim_diagnostics" {
  description = "Send APIM gateway logs to Log Analytics"
  type        = bool
  default     = false
}

variable "apim_resource_id" {
  description = "Resource ID of the API Management service for diagnostic settings"
  type        = string
  default     = ""
}

variable "enable_prometheus_collection" {
  description = "Create a data collection rule to forward Prometheus metrics to Azure Monitor workspace"
  type        = bool
  default     = false
}

variable "azure_monitor_workspace_id" {
  description = "Resource ID of the Azure Monitor workspace for Prometheus ingestion"
  type        = string
  default     = ""
}

variable "enable_workbooks" {
  description = "Create Application Insights workbooks for API health and cost overview"
  type        = bool
  default     = false
}

variable "enable_maintenance_suppression" {
  description = "Create an alert processing rule to suppress Sev2-4 alerts during weekend maintenance windows"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace for diagnostic settings and alerts"
  type        = string
  default     = ""
}

variable "warning_action_group_id" {
  description = "Resource ID of the action group for warning-severity alerts"
  type        = string
  default     = ""
}

variable "critical_action_group_id" {
  description = "Resource ID of the action group for critical-severity alerts"
  type        = string
  default     = ""
}

variable "enable_alert_routing" {
  description = "Create an alert processing rule to route Sev0-1 alerts to the on-call action group"
  type        = bool
  default     = false
}
