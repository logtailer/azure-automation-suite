# Dev environment observability configuration
resource_group_name          = "rg-observability-dev"
location                     = "Central India"
log_analytics_workspace_name = "law-platform-dev"
log_analytics_sku            = "PerGB2018"
log_retention_days           = 30
application_insights_name    = "appinsights-platform-dev"
action_group_name            = "alerts-dev"
admin_email                  = "platform-team@example.com"
grafana_name                 = "grafana-platform-dev"
environment                  = "dev"
component_name               = "observability"

enable_idp_monitoring     = false
enable_prometheus_metrics = false
enable_component_budget   = true
component_budget_amount   = 15
cost_alert_threshold      = 80
cost_alert_emails         = ["platform-team@example.com"]

aks_cluster_id     = ""
storage_account_id = ""

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "observability"
  CostCenter  = "engineering"
}
