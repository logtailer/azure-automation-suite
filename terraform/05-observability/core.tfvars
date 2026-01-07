# Observability module configuration
resource_group_name = "rg-observability"
location            = "Central India"

log_analytics_workspace_name = "law-platform-monitoring"
application_insights_name    = "appinsights-platform"
action_group_name            = "alerts-platform-team"
admin_email                  = "admin@example.com"

tags = {
  Environment = "Production"
  Project     = "Platform"
  Component   = "Observability"
}
