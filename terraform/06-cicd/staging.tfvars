# Staging environment CI/CD configuration
resource_group_name = "azure-platform-staging-rg"
environment         = "staging"

github_repository_owner = "your-github-username"
github_repository_name  = "azure-automation-suite"

runner_node_min_count = 1
runner_node_max_count = 5
runner_min_replicas   = 1
runner_max_replicas   = 5

argocd_namespace     = "argocd"
argocd_chart_version = "5.51.6"

enable_component_budget = true
component_budget_amount = 150
cost_alert_threshold    = 80
cost_alert_emails       = ["platform-team@example.com"]
