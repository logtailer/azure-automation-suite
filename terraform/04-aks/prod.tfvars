# Production environment AKS configuration
resource_group_name = "aks-prod-rg"
location            = "Central India"
cluster_name        = "aks-platform-prod"

node_pool_vm_size   = "Standard_D8s_v3"
node_count          = 3
min_node_count      = 3
max_node_count      = 15
enable_auto_scaling = true

upgrade_max_surge        = "33%"
upgrade_drain_timeout    = 30
upgrade_node_soak_period = 5

kubernetes_version = "1.30"
network_plugin     = "azure"
network_policy     = "calico"
load_balancer_sku  = "standard"
outbound_type      = "loadBalancer"

enable_private_cluster     = true
enable_azure_policy        = true
enable_oms_agent           = true
log_analytics_workspace_id = ""

tags = {
  Environment = "production"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "aks"
  CostCenter  = "engineering"
}
