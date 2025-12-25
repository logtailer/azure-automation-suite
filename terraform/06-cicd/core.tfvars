# CI/CD module configuration
resource_group_name = "rg-cicd"
location = "East US"

container_registry_name = "acrplatformcicd001"
container_registry_sku = "Standard"
acr_admin_enabled = true

artifacts_storage_name = "stplatformartifacts001"

vmss_name = "vmss-buildagents"
vmss_sku = "Standard_D2s_v3"
vmss_instances = 3

admin_username = "buildagent"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... # Add your SSH public key here"

# TODO: Replace with actual subnet ID from networking module
subnet_id = "/subscriptions/sub-id/resourceGroups/rg-networking/providers/Microsoft.Network/virtualNetworks/vnet-platform/subnets/subnet-cicd"

tags = {
  Environment = "Production"
  Project     = "Platform"
  Component   = "CI/CD"
}
