# Observability module configuration
resource_group_name = "rg-observability"
location            = "Central India"

log_analytics_workspace_name = "law-platform-monitoring"
application_insights_name    = "appinsights-platform"
action_group_name            = "alerts-platform-team"
admin_email                  = "admin@example.com"

# IDP Integration
enable_idp_monitoring     = true
enable_prometheus_metrics = true
environment               = "production"

tags = {
  Environment = "Production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}

# Cost monitoring
enable_component_budget = true
component_budget_amount = 20
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]

# On-call integration (set via environment variables)
# TF_VAR_pagerduty_webhook_url or TF_VAR_opsgenie_webhook_url
enable_pagerduty_integration = false
enable_opsgenie_integration  = false
