locals {
  aks_node_pool_1_subnet_id = data.terraform_remote_state.networking.outputs.private_subnet1_id
  aks_node_pool_2_subnet_id = data.terraform_remote_state.networking.outputs.private_subnet2_id
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  name                   = var.usr_node_pool_name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  vm_size                = var.usr_node_pool_vm_size
  kubelet_disk_type      = "OS"
  os_disk_type           = "Managed"
  max_pods               = var.usr_node_pool_max_pods
  auto_scaling_enabled   = var.usr_node_pool_scaling
  mode                   = "User"
  max_count              = var.usr_node_pool_max_count
  min_count              = var.usr_node_pool_min_count
  node_count             = var.usr_node_pool_count
  node_public_ip_enabled = var.usr_node_pool_public_ip_enabled
  scale_down_mode        = var.usr_node_pool_scale_down_mode
  os_disk_size_gb        = var.usr_node_pool_os_disk_size_gb
  os_sku                 = var.usr_node_pool_os_sku
  os_type                = var.usr_node_pool_os_type
  vnet_subnet_id         = local.aks_node_pool_1_subnet_id

  node_network_profile {
    allowed_host_ports {
      port_start = 30011
      port_end   = 30011
      protocol   = "TCP"
    }
    allowed_host_ports {
      port_start = 22
      port_end   = 22
      protocol   = "TCP"
    }
    application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool_2" {
  name                   = var.usr_node_pool_2_name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  vm_size                = var.usr_node_pool_2_vm_size
  kubelet_disk_type      = "OS"
  os_disk_type           = "Managed"
  max_pods               = var.usr_node_pool_2_max_pods
  auto_scaling_enabled   = var.usr_node_pool_2_scaling
  mode                   = "User"
  max_count              = var.usr_node_pool_2_max_count
  min_count              = var.usr_node_pool_2_min_count
  node_count             = var.usr_node_pool_2_count
  node_public_ip_enabled = var.usr_node_pool_2_public_ip_enabled
  scale_down_mode        = var.usr_node_pool_2_scale_down_mode
  os_disk_size_gb        = var.usr_node_pool_2_os_disk_size_gb
  os_sku                 = var.usr_node_pool_2_os_sku
  os_type                = var.usr_node_pool_2_os_type
  vnet_subnet_id         = local.aks_node_pool_2_subnet_id

  node_network_profile {
    allowed_host_ports {
      port_start = 30011
      port_end   = 30011
      protocol   = "TCP"
    }
    allowed_host_ports {
      port_start = 22
      port_end   = 22
      protocol   = "TCP"
    }
    application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }
}
