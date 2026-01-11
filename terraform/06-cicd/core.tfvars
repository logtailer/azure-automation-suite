component_name               = "cicd"
location                     = "Central India"
tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# AKS configuration
kubernetes_version = "1.28"
aks_dns_prefix     = "aks-cicd"

# Node pool sizing
system_node_count = 1
system_node_size  = "Standard_B2s"
runner_node_size  = "Standard_D2s_v3"

# Runner scaling
runner_node_min_count = 0
runner_node_max_count = 5
runner_min_replicas   = 0
runner_max_replicas   = 5

# ArgoCD configuration
argocd_chart_version = "7.0.0"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
}
