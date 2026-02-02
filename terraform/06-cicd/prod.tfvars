# Production environment CI/CD configuration
resource_group_name = "azure-platform-prod-rg"
environment         = "prod"

github_repository_owner = "your-github-username"
github_repository_name  = "azure-automation-suite"

runner_node_min_count = 2
runner_node_max_count = 10
runner_min_replicas   = 2
runner_max_replicas   = 10

argocd_namespace     = "argocd"
argocd_chart_version = "5.51.6"

enable_component_budget = true
component_budget_amount = 300
cost_alert_threshold    = 75
cost_alert_emails       = ["platform-team@example.com", "oncall@example.com"]
