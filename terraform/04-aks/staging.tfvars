# Staging environment AKS configuration
resource_group_name = "aks-staging-rg"
location            = "Central India"
cluster_name        = "aks-platform-staging"

node_pool_vm_size   = "Standard_D4s_v3"
node_count          = 2
min_node_count      = 2
max_node_count      = 6
enable_auto_scaling = true

kubernetes_version         = "1.29"
network_plugin             = "azure"
network_policy             = "calico"
load_balancer_sku          = "standard"
outbound_type              = "loadBalancer"

enable_private_cluster     = false
enable_azure_policy        = true
enable_oms_agent           = true
log_analytics_workspace_id = ""

tags = {
  Environment = "staging"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "aks"
  CostCenter  = "engineering"
}
