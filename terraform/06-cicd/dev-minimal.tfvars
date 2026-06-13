location            = "Central India"
resource_group_name = "cicd-dev-rg"
environment         = "dev"
component_name      = "cicd"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# ARC + runners — smallest viable nodes
kubernetes_version    = "1.30"
aks_dns_prefix        = "aks-cicd-dev"
system_node_count     = 1
system_node_size      = "Standard_B2s"
runner_node_size      = "Standard_B2s"
runner_node_min_count = 1
runner_node_max_count = 2

# ARC
arc_namespace         = "arc-runners"
runner_scale_set_name = "arc-runner-set"
runner_min_replicas   = 1
runner_max_replicas   = 4

# ArgoCD
argocd_namespace     = "argocd"
argocd_chart_version = "7.3.4"

# GitHub — fill in before deploying
github_token            = "REPLACE_ME"
github_webhook_secret   = "REPLACE_ME"
github_repository_owner = "REPLACE_ME"
github_repository_name  = "azure-automation-suite"

# Budget
enable_component_budget = false
component_budget_amount = 10
cost_alert_threshold    = 80
cost_alert_emails       = ["anandsumit2000@gmail.com"]

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
