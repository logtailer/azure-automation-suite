location            = "Central India"
resource_group_name = "observability-dev-rg"
environment         = "dev"
component_name      = "observability"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Log Analytics — 30-day retention keeps costs low
log_analytics_workspace_name = "law-dev-platform"
log_analytics_sku            = "PerGB2018"
log_retention_days           = 30

# App Insights — low sampling to reduce ingestion
application_insights_name        = "appi-dev-platform"
enable_app_insights              = true
app_insights_retention_days      = 30
app_insights_sampling_percentage = 10

# Action group
action_group_name = "ag-dev-platform"
admin_email       = "anandsumit2000@gmail.com"

# Alert tuning
alert_window_size          = "PT5M"
alert_evaluation_frequency = "PT1M"
critical_alert_emails      = ["anandsumit2000@gmail.com"]
warning_alert_emails       = ["anandsumit2000@gmail.com"]

# Disable expensive integrations
enable_pagerduty_integration   = false
enable_opsgenie_integration    = false
enable_audit_workspace         = false
enable_otel_collector          = false
enable_synthetic_monitor       = false
enable_slo_alerts              = false
enable_prometheus_metrics      = false
enable_prometheus_collection   = false
enable_data_collection_rule    = false
enable_network_alerts          = false
enable_workbooks               = false
enable_maintenance_suppression = false
enable_alert_routing           = false
enable_cost_budget             = false
enable_idp_monitoring          = false

# AKS alerts — enabled but no cluster ID yet
enable_aks_alerts          = false
aks_cluster_id             = ""
aks_cpu_alert_threshold    = 80
aks_memory_alert_threshold = 80

# Grafana (Managed Grafana is ~$3/day — leave name set, disable in main if needed)
grafana_name = "grafana-dev-platform"

monthly_budget_amount   = 20
enable_component_budget = false
cost_alert_threshold    = 80
cost_alert_emails       = ["anandsumit2000@gmail.com"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
