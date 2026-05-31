# Production environment observability configuration
resource_group_name          = "rg-observability-prod"
location                     = "Central India"
log_analytics_workspace_name = "law-platform-prod"
log_analytics_sku            = "PerGB2018"
log_retention_days           = 90
application_insights_name    = "appinsights-platform-prod"
action_group_name            = "alerts-prod"
admin_email                  = "platform-team@example.com"
grafana_name                 = "grafana-platform-prod"
environment                  = "prod"
component_name               = "observability"

enable_idp_monitoring     = true
enable_prometheus_metrics = true
enable_component_budget   = true
component_budget_amount   = 60
cost_alert_threshold      = 75
cost_alert_emails         = ["platform-team@example.com", "oncall@example.com"]

aks_cluster_id     = ""
storage_account_id = ""

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "observability"
  CostCenter  = "engineering"
}
