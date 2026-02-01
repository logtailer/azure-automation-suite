# Staging environment observability configuration
resource_group_name          = "rg-observability-staging"
location                     = "Central India"
log_analytics_workspace_name = "law-platform-staging"
log_analytics_sku            = "PerGB2018"
log_retention_days           = 60
application_insights_name    = "appinsights-platform-staging"
action_group_name            = "alerts-staging"
admin_email                  = "platform-team@example.com"
grafana_name                 = "grafana-platform-staging"
environment                  = "staging"
component_name               = "observability"

enable_idp_monitoring      = true
enable_prometheus_metrics  = true
enable_component_budget    = true
component_budget_amount    = 30
cost_alert_threshold       = 80
cost_alert_emails          = ["platform-team@example.com"]

aks_cluster_id     = ""
storage_account_id = ""

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "observability"
  CostCenter  = "engineering"
}
