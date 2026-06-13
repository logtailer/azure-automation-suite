location            = "Central India"
resource_group_name = "aks-dev-rg"
environment         = "dev"

tfstate_resource_group_name  = "terraform-state-rg"
tfstate_storage_account_name = "sumittfstatestorage"

# Cluster — Free tier, smallest viable node
cluster_name       = "aks-dev"
cluster_dns_prefix = "aks-dev"
kubernetes_version = "1.30"
aks_sku_tier       = "Free"
support_plan       = "KubernetesOfficial"

# System node pool — single B2s node
vm_size             = "Standard_B2s"
default_node_count  = 1
os_disk_size_gb     = 30
node_pool_scaling   = true
node_pool_min_count = 1
node_pool_max_count = 2
node_pool_count     = 1

# User node pool — single B2s node
usr_node_pool_name            = "userpool"
usr_node_pool_vm_size         = "Standard_B2s"
usr_node_pool_count           = 1
usr_node_pool_scaling         = true
usr_node_pool_min_count       = 1
usr_node_pool_max_count       = 2
usr_node_pool_os_disk_size_gb = 30

# Second user pool — disabled (count = 0)
usr_node_pool_2_name      = "userpool2"
usr_node_pool_2_vm_size   = "Standard_B2s"
usr_node_pool_2_count     = 0
usr_node_pool_2_scaling   = false
usr_node_pool_2_min_count = 0
usr_node_pool_2_max_count = 0

# Networking
network_plugin          = "azure"
network_policy          = "azure"
network_plugin_mode     = "overlay"
outbound_type           = "loadBalancer"
pod_cidr                = "192.168.0.0/16"
service_cidr            = "10.96.0.0/16"
dns_service_ip          = "10.96.0.10"
load_balancer_sku       = "standard"
private_cluster_enabled = false

# Disable all optional add-ons (save cost + complexity)
enable_istio                = false
enable_velero               = false
enable_flux                 = false
enable_dapr                 = false
enable_gpu_node_pool        = false
enable_windows_node_pool    = false
enable_spot_node_pool       = false
spot_node_pool_enabled      = false
enable_aks_autoscale_alerts = false
cost_analysis_enabled       = false

# Features — keep minimal
azure_policy_enabled            = false
local_account_disabled          = false
image_cleaner_enabled           = false
vertical_pod_autoscaler_enabled = false
blob_driver_enabled             = false

# ACR
acr_name                = "acrdevplatform001"
acr_resource_group_name = "azure-platform-dev-rg"

# Log Analytics
log_analytics_workspace_id = ""

# VM (bastion helper VM)
vm_name            = "vm-dev-bastion"
admin_username     = "azureuser"
os_disk_size       = 30
vm_image_publisher = "Canonical"
vm_image_offer     = "0001-com-ubuntu-server-jammy"
vm_image_sku       = "22_04-lts"
vm_image_version   = "latest"
project_name       = "azure-platform"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
