resource "azurerm_kubernetes_cluster" "cluster" {
  name                      = var.cluster_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.cluster_dns_prefix
  kubernetes_version        = var.kubernetes_version
  sku_tier                  = var.aks_sku_tier
  automatic_upgrade_channel = var.automatic_upgrade_channel
  cost_analysis_enabled     = var.cost_analysis_enabled
  tags                      = var.tags

  identity {
    type = "SystemAssigned"
  }

  node_os_upgrade_channel = var.node_os_upgrade_channel
  node_resource_group     = var.aks_node_resource_group_name

  default_node_pool {
    name                         = var.sys_node_pool_name
    vm_size                      = var.vm_size
    kubelet_disk_type            = var.kubelet_disk_type
    os_disk_type                 = var.os_disk_type
    max_pods                     = var.node_pool_max_pods
    auto_scaling_enabled         = var.node_pool_scaling
    type                         = "VirtualMachineScaleSets"
    max_count                    = var.node_pool_max_count
    min_count                    = var.node_pool_min_count
    node_count                   = var.node_pool_count
    node_public_ip_enabled       = var.node_public_ip_enabled
    scale_down_mode              = var.node_pool_scale_down_mode
    only_critical_addons_enabled = var.default_node_pool_only_critical_addons
    os_disk_size_gb              = var.node_pool_os_disk_size_gb
    os_sku                       = var.node_pool_os_sku
    vnet_subnet_id               = var.vnet_subnet_id
    upgrade_settings {
      drain_timeout_in_minutes      = var.node_pool_drain_timeout
      node_soak_duration_in_minutes = var.node_pool_soak_duration
      max_surge                     = var.node_pool_max_surge
    }
  }

  run_command_enabled = var.run_command_enabled
  storage_profile {
    blob_driver_enabled         = var.blob_driver_enabled
    disk_driver_enabled         = var.disk_driver_enabled
    file_driver_enabled         = var.file_driver_enabled
    snapshot_controller_enabled = var.snapshot_controller_enabled
  }
  support_plan = var.support_plan

  auto_scaler_profile {
    max_graceful_termination_sec  = var.autoscaler_max_graceful_termination_sec
    max_node_provisioning_time    = var.autoscaler_max_node_provisioning_time
    max_unready_nodes             = var.autoscaler_max_unready_nodes
    scale_down_delay_after_add    = var.autoscaler_scale_down_delay_after_add
    skip_nodes_with_local_storage = var.autoscaler_skip_nodes_with_local_storage
    skip_nodes_with_system_pods   = var.autoscaler_skip_nodes_with_system_pods
  }

  workload_autoscaler_profile {
    vertical_pod_autoscaler_enabled = var.vertical_pod_autoscaler_enabled
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_policy      = var.network_policy
    network_plugin_mode = var.network_plugin_mode
    outbound_type       = var.outbound_type
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    ip_versions         = var.ip_versions
    load_balancer_sku   = var.load_balancer_sku
  }
  private_cluster_enabled           = var.private_cluster_enabled
  role_based_access_control_enabled = var.role_based_access_control_enabled
  azure_policy_enabled              = var.azure_policy_enabled
  local_account_disabled            = var.local_account_disabled

  maintenance_window {
    allowed {
      day   = var.maintenance_window_allowed_day
      hours = var.maintenance_window_allowed_hours
    }
  }

  maintenance_window_auto_upgrade {
    frequency   = var.maintenance_window_auto_upgrade_frequency
    interval    = var.maintenance_window_auto_upgrade_interval
    duration    = var.maintenance_window_auto_upgrade_duration
    day_of_week = var.maintenance_window_auto_upgrade_day_of_week
    week_index  = var.maintenance_window_auto_upgrade_week_index
    start_time  = var.maintenance_window_auto_upgrade_start_time
    utc_offset  = var.maintenance_window_auto_upgrade_utc_offset
    not_allowed {
      start = var.maintenance_window_auto_upgrade_not_allowed_start
      end   = var.maintenance_window_auto_upgrade_not_allowed_end
    }
  }

  maintenance_window_node_os {
    frequency   = var.maintenance_window_node_os_frequency
    interval    = var.maintenance_window_node_os_interval
    duration    = var.maintenance_window_node_os_duration
    day_of_week = var.maintenance_window_node_os_day_of_week
    start_time  = var.maintenance_window_node_os_start_time
    utc_offset  = var.maintenance_window_node_os_utc_offset
    not_allowed {
      start = var.maintenance_window_node_os_not_allowed_start
      end   = var.maintenance_window_node_os_not_allowed_end
    }
  }

  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours
}