# Dev environment AKS configuration
resource_group_name = "aks-dev-rg"
location            = "Central India"
cluster_name        = "aks-platform-dev"

node_pool_vm_size   = "Standard_D2s_v3"
node_count          = 1
min_node_count      = 1
max_node_count      = 3
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
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  Component   = "aks"
  CostCenter  = "engineering"
}
