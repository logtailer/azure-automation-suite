resource_group_name = "azure-platform-dev-rg"
environment         = "dev"

# GitHub configuration (set via environment variables)
# TF_VAR_github_token, TF_VAR_github_webhook_secret
github_repository_owner = "your-github-username"
github_repository_name  = "azure-automation-suite"

# Cost monitoring
enable_component_budget = true
component_budget_amount = 100
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]
