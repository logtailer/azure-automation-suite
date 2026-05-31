# 04-aks

## Purpose
This component manages AKS (Azure Kubernetes Service) resources.

## Usage
- Edit `core.tfvars` with your values.
- Run `deploy.sh` or use Terraform CLI.

## Variables
- Add AKS-specific variables in `variables.tf`.

## Outputs
- Add outputs in `outputs.tf` as needed.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights_workbook.aks_node_health](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) | resource |
| [azurerm_bastion_host.aks_bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_extension.dapr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) | resource |
| [azurerm_kubernetes_cluster_extension.flux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) | resource |
| [azurerm_kubernetes_cluster_node_pool.gpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.spot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.user_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.user_node_pool_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_flux_configuration.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_flux_configuration) | resource |
| [azurerm_linux_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_monitor_autoscale_setting.aks_user_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_monitor_diagnostic_setting.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_interface_security_group_association.vm_nic_nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.vm_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.bastion_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [kubernetes_network_policy.allow_same_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_system_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.deny_all_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.istio_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.vm_key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_container_registry.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | Name of an existing Azure Container Registry to grant AcrPull to the AKS kubelet identity | `string` | `""` | no |
| <a name="input_acr_resource_group_name"></a> [acr\_resource\_group\_name](#input\_acr\_resource\_group\_name) | Resource group containing the ACR referenced by acr\_name | `string` | `""` | no |
| <a name="input_aks_node_resource_group_name"></a> [aks\_node\_resource\_group\_name](#input\_aks\_node\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | n/a | `string` | n/a | yes |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | List of CIDR blocks authorized to access the Kubernetes API server | `list(string)` | `[]` | no |
| <a name="input_automatic_upgrade_channel"></a> [automatic\_upgrade\_channel](#input\_automatic\_upgrade\_channel) | n/a | `string` | n/a | yes |
| <a name="input_autoscaler_max_graceful_termination_sec"></a> [autoscaler\_max\_graceful\_termination\_sec](#input\_autoscaler\_max\_graceful\_termination\_sec) | n/a | `number` | n/a | yes |
| <a name="input_autoscaler_max_node_provisioning_time"></a> [autoscaler\_max\_node\_provisioning\_time](#input\_autoscaler\_max\_node\_provisioning\_time) | n/a | `string` | n/a | yes |
| <a name="input_autoscaler_max_unready_nodes"></a> [autoscaler\_max\_unready\_nodes](#input\_autoscaler\_max\_unready\_nodes) | n/a | `number` | n/a | yes |
| <a name="input_autoscaler_scale_down_delay_after_add"></a> [autoscaler\_scale\_down\_delay\_after\_add](#input\_autoscaler\_scale\_down\_delay\_after\_add) | n/a | `string` | n/a | yes |
| <a name="input_autoscaler_skip_nodes_with_local_storage"></a> [autoscaler\_skip\_nodes\_with\_local\_storage](#input\_autoscaler\_skip\_nodes\_with\_local\_storage) | n/a | `bool` | n/a | yes |
| <a name="input_autoscaler_skip_nodes_with_system_pods"></a> [autoscaler\_skip\_nodes\_with\_system\_pods](#input\_autoscaler\_skip\_nodes\_with\_system\_pods) | n/a | `bool` | n/a | yes |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_bastion_subnet_id"></a> [bastion\_subnet\_id](#input\_bastion\_subnet\_id) | The subnet ID for Azure Bastion. Should be a subnet named 'AzureBastionSubnet' in your VNet. | `string` | n/a | yes |
| <a name="input_blob_driver_enabled"></a> [blob\_driver\_enabled](#input\_blob\_driver\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_cluster_dns_prefix"></a> [cluster\_dns\_prefix](#input\_cluster\_dns\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the AKS cluster | `string` | n/a | yes |
| <a name="input_cost_analysis_enabled"></a> [cost\_analysis\_enabled](#input\_cost\_analysis\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_default_node_count"></a> [default\_node\_count](#input\_default\_node\_count) | n/a | `number` | n/a | yes |
| <a name="input_default_node_pool_only_critical_addons"></a> [default\_node\_pool\_only\_critical\_addons](#input\_default\_node\_pool\_only\_critical\_addons) | n/a | `bool` | n/a | yes |
| <a name="input_disk_driver_enabled"></a> [disk\_driver\_enabled](#input\_disk\_driver\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | n/a | `string` | n/a | yes |
| <a name="input_enable_aks_autoscale_alerts"></a> [enable\_aks\_autoscale\_alerts](#input\_enable\_aks\_autoscale\_alerts) | Create Monitor autoscale settings for the AKS user node pool | `bool` | `false` | no |
| <a name="input_enable_dapr"></a> [enable\_dapr](#input\_enable\_dapr) | Install the Dapr AKS cluster extension for distributed application runtime | `bool` | `false` | no |
| <a name="input_enable_flux"></a> [enable\_flux](#input\_enable\_flux) | Install the Flux AKS cluster extension for GitOps reconciliation | `bool` | `false` | no |
| <a name="input_enable_gpu_node_pool"></a> [enable\_gpu\_node\_pool](#input\_enable\_gpu\_node\_pool) | Add a GPU node pool with nvidia taint for ML workloads | `bool` | `false` | no |
| <a name="input_enable_istio"></a> [enable\_istio](#input\_enable\_istio) | Enable Istio service mesh via Azure AKS mesh add-on | `bool` | `false` | no |
| <a name="input_enable_spot_node_pool"></a> [enable\_spot\_node\_pool](#input\_enable\_spot\_node\_pool) | Add a Spot priority node pool for cost-optimised batch workloads | `bool` | `false` | no |
| <a name="input_enable_velero"></a> [enable\_velero](#input\_enable\_velero) | Provision Velero backup storage account and managed identity for AKS cluster backups | `bool` | `false` | no |
| <a name="input_enable_windows_node_pool"></a> [enable\_windows\_node\_pool](#input\_enable\_windows\_node\_pool) | Add a Windows Server 2022 node pool for legacy .NET workloads | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_file_driver_enabled"></a> [file\_driver\_enabled](#input\_file\_driver\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_flux_git_repository_url"></a> [flux\_git\_repository\_url](#input\_flux\_git\_repository\_url) | Git repository URL for Flux to watch for cluster manifests | `string` | `""` | no |
| <a name="input_gpu_node_count"></a> [gpu\_node\_count](#input\_gpu\_node\_count) | Number of GPU nodes in the pool | `number` | `1` | no |
| <a name="input_gpu_node_vm_size"></a> [gpu\_node\_vm\_size](#input\_gpu\_node\_vm\_size) | VM size for the GPU node pool (e.g. Standard\_NC6s\_v3) | `string` | `"Standard_NC6s_v3"` | no |
| <a name="input_image_cleaner_enabled"></a> [image\_cleaner\_enabled](#input\_image\_cleaner\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | n/a | `number` | n/a | yes |
| <a name="input_ip_versions"></a> [ip\_versions](#input\_ip\_versions) | n/a | `list(string)` | n/a | yes |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Istio revision to install (e.g. asm-1-20) | `string` | `"asm-1-20"` | no |
| <a name="input_kubelet_disk_type"></a> [kubelet\_disk\_type](#input\_kubelet\_disk\_type) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | n/a | yes |
| <a name="input_load_balancer_sku"></a> [load\_balancer\_sku](#input\_load\_balancer\_sku) | n/a | `string` | n/a | yes |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled) | n/a | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for AKS diagnostic settings and Container Insights | `string` | `""` | no |
| <a name="input_maintenance_window_allowed_day"></a> [maintenance\_window\_allowed\_day](#input\_maintenance\_window\_allowed\_day) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_allowed_hours"></a> [maintenance\_window\_allowed\_hours](#input\_maintenance\_window\_allowed\_hours) | n/a | `list(number)` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_day_of_week"></a> [maintenance\_window\_auto\_upgrade\_day\_of\_week](#input\_maintenance\_window\_auto\_upgrade\_day\_of\_week) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_duration"></a> [maintenance\_window\_auto\_upgrade\_duration](#input\_maintenance\_window\_auto\_upgrade\_duration) | n/a | `number` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_frequency"></a> [maintenance\_window\_auto\_upgrade\_frequency](#input\_maintenance\_window\_auto\_upgrade\_frequency) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_interval"></a> [maintenance\_window\_auto\_upgrade\_interval](#input\_maintenance\_window\_auto\_upgrade\_interval) | n/a | `number` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_not_allowed_end"></a> [maintenance\_window\_auto\_upgrade\_not\_allowed\_end](#input\_maintenance\_window\_auto\_upgrade\_not\_allowed\_end) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_not_allowed_start"></a> [maintenance\_window\_auto\_upgrade\_not\_allowed\_start](#input\_maintenance\_window\_auto\_upgrade\_not\_allowed\_start) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_start_time"></a> [maintenance\_window\_auto\_upgrade\_start\_time](#input\_maintenance\_window\_auto\_upgrade\_start\_time) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_utc_offset"></a> [maintenance\_window\_auto\_upgrade\_utc\_offset](#input\_maintenance\_window\_auto\_upgrade\_utc\_offset) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_auto_upgrade_week_index"></a> [maintenance\_window\_auto\_upgrade\_week\_index](#input\_maintenance\_window\_auto\_upgrade\_week\_index) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_day_of_week"></a> [maintenance\_window\_node\_os\_day\_of\_week](#input\_maintenance\_window\_node\_os\_day\_of\_week) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_duration"></a> [maintenance\_window\_node\_os\_duration](#input\_maintenance\_window\_node\_os\_duration) | n/a | `number` | n/a | yes |
| <a name="input_maintenance_window_node_os_frequency"></a> [maintenance\_window\_node\_os\_frequency](#input\_maintenance\_window\_node\_os\_frequency) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_interval"></a> [maintenance\_window\_node\_os\_interval](#input\_maintenance\_window\_node\_os\_interval) | n/a | `number` | n/a | yes |
| <a name="input_maintenance_window_node_os_not_allowed_end"></a> [maintenance\_window\_node\_os\_not\_allowed\_end](#input\_maintenance\_window\_node\_os\_not\_allowed\_end) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_not_allowed_start"></a> [maintenance\_window\_node\_os\_not\_allowed\_start](#input\_maintenance\_window\_node\_os\_not\_allowed\_start) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_start_time"></a> [maintenance\_window\_node\_os\_start\_time](#input\_maintenance\_window\_node\_os\_start\_time) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window_node_os_utc_offset"></a> [maintenance\_window\_node\_os\_utc\_offset](#input\_maintenance\_window\_node\_os\_utc\_offset) | n/a | `string` | n/a | yes |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | n/a | `string` | n/a | yes |
| <a name="input_network_plugin_mode"></a> [network\_plugin\_mode](#input\_network\_plugin\_mode) | n/a | `string` | n/a | yes |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | n/a | `string` | n/a | yes |
| <a name="input_node_os_upgrade_channel"></a> [node\_os\_upgrade\_channel](#input\_node\_os\_upgrade\_channel) | n/a | `string` | n/a | yes |
| <a name="input_node_pool_count"></a> [node\_pool\_count](#input\_node\_pool\_count) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_drain_timeout"></a> [node\_pool\_drain\_timeout](#input\_node\_pool\_drain\_timeout) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_max_count"></a> [node\_pool\_max\_count](#input\_node\_pool\_max\_count) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_max_pods"></a> [node\_pool\_max\_pods](#input\_node\_pool\_max\_pods) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_max_surge"></a> [node\_pool\_max\_surge](#input\_node\_pool\_max\_surge) | n/a | `string` | n/a | yes |
| <a name="input_node_pool_min_count"></a> [node\_pool\_min\_count](#input\_node\_pool\_min\_count) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_os_disk_size_gb"></a> [node\_pool\_os\_disk\_size\_gb](#input\_node\_pool\_os\_disk\_size\_gb) | n/a | `number` | n/a | yes |
| <a name="input_node_pool_os_sku"></a> [node\_pool\_os\_sku](#input\_node\_pool\_os\_sku) | n/a | `string` | n/a | yes |
| <a name="input_node_pool_scale_down_mode"></a> [node\_pool\_scale\_down\_mode](#input\_node\_pool\_scale\_down\_mode) | n/a | `string` | n/a | yes |
| <a name="input_node_pool_scaling"></a> [node\_pool\_scaling](#input\_node\_pool\_scaling) | n/a | `bool` | n/a | yes |
| <a name="input_node_pool_soak_duration"></a> [node\_pool\_soak\_duration](#input\_node\_pool\_soak\_duration) | n/a | `number` | n/a | yes |
| <a name="input_node_public_ip_enabled"></a> [node\_public\_ip\_enabled](#input\_node\_public\_ip\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | n/a | `number` | n/a | yes |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | n/a | `string` | n/a | yes |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | n/a | `string` | n/a | yes |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_run_command_enabled"></a> [run\_command\_enabled](#input\_run\_command\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_snapshot_controller_enabled"></a> [snapshot\_controller\_enabled](#input\_snapshot\_controller\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_spot_max_count"></a> [spot\_max\_count](#input\_spot\_max\_count) | Maximum node count for the Spot autoscaler pool | `number` | `10` | no |
| <a name="input_spot_node_pool_enabled"></a> [spot\_node\_pool\_enabled](#input\_spot\_node\_pool\_enabled) | Enable a spot instance node pool for cost-optimized workloads | `bool` | `false` | no |
| <a name="input_spot_node_pool_vm_size"></a> [spot\_node\_pool\_vm\_size](#input\_spot\_node\_pool\_vm\_size) | VM size for the spot node pool | `string` | `"Standard_D4s_v3"` | no |
| <a name="input_spot_vm_size"></a> [spot\_vm\_size](#input\_spot\_vm\_size) | VM size for the Spot node pool | `string` | `"Standard_D4s_v3"` | no |
| <a name="input_support_plan"></a> [support\_plan](#input\_support\_plan) | n/a | `string` | n/a | yes |
| <a name="input_sys_node_pool_name"></a> [sys\_node\_pool\_name](#input\_sys\_node\_pool\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_usr_node_pool_2_count"></a> [usr\_node\_pool\_2\_count](#input\_usr\_node\_pool\_2\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_2_max_count"></a> [usr\_node\_pool\_2\_max\_count](#input\_usr\_node\_pool\_2\_max\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_2_max_pods"></a> [usr\_node\_pool\_2\_max\_pods](#input\_usr\_node\_pool\_2\_max\_pods) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_2_min_count"></a> [usr\_node\_pool\_2\_min\_count](#input\_usr\_node\_pool\_2\_min\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_2_name"></a> [usr\_node\_pool\_2\_name](#input\_usr\_node\_pool\_2\_name) | Second User Node Pool variables | `string` | n/a | yes |
| <a name="input_usr_node_pool_2_os_disk_size_gb"></a> [usr\_node\_pool\_2\_os\_disk\_size\_gb](#input\_usr\_node\_pool\_2\_os\_disk\_size\_gb) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_2_os_sku"></a> [usr\_node\_pool\_2\_os\_sku](#input\_usr\_node\_pool\_2\_os\_sku) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_2_os_type"></a> [usr\_node\_pool\_2\_os\_type](#input\_usr\_node\_pool\_2\_os\_type) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_2_public_ip_enabled"></a> [usr\_node\_pool\_2\_public\_ip\_enabled](#input\_usr\_node\_pool\_2\_public\_ip\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_usr_node_pool_2_scale_down_mode"></a> [usr\_node\_pool\_2\_scale\_down\_mode](#input\_usr\_node\_pool\_2\_scale\_down\_mode) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_2_scaling"></a> [usr\_node\_pool\_2\_scaling](#input\_usr\_node\_pool\_2\_scaling) | n/a | `bool` | n/a | yes |
| <a name="input_usr_node_pool_2_vm_size"></a> [usr\_node\_pool\_2\_vm\_size](#input\_usr\_node\_pool\_2\_vm\_size) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_count"></a> [usr\_node\_pool\_count](#input\_usr\_node\_pool\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_max_count"></a> [usr\_node\_pool\_max\_count](#input\_usr\_node\_pool\_max\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_max_pods"></a> [usr\_node\_pool\_max\_pods](#input\_usr\_node\_pool\_max\_pods) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_min_count"></a> [usr\_node\_pool\_min\_count](#input\_usr\_node\_pool\_min\_count) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_name"></a> [usr\_node\_pool\_name](#input\_usr\_node\_pool\_name) | User Node Pool variables | `string` | n/a | yes |
| <a name="input_usr_node_pool_os_disk_size_gb"></a> [usr\_node\_pool\_os\_disk\_size\_gb](#input\_usr\_node\_pool\_os\_disk\_size\_gb) | n/a | `number` | n/a | yes |
| <a name="input_usr_node_pool_os_sku"></a> [usr\_node\_pool\_os\_sku](#input\_usr\_node\_pool\_os\_sku) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_os_type"></a> [usr\_node\_pool\_os\_type](#input\_usr\_node\_pool\_os\_type) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_public_ip_enabled"></a> [usr\_node\_pool\_public\_ip\_enabled](#input\_usr\_node\_pool\_public\_ip\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_usr_node_pool_scale_down_mode"></a> [usr\_node\_pool\_scale\_down\_mode](#input\_usr\_node\_pool\_scale\_down\_mode) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_scaling"></a> [usr\_node\_pool\_scaling](#input\_usr\_node\_pool\_scaling) | n/a | `bool` | n/a | yes |
| <a name="input_usr_node_pool_vm_size"></a> [usr\_node\_pool\_vm\_size](#input\_usr\_node\_pool\_vm\_size) | n/a | `string` | n/a | yes |
| <a name="input_usr_node_pool_vnet_subnet_id"></a> [usr\_node\_pool\_vnet\_subnet\_id](#input\_usr\_node\_pool\_vnet\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_vertical_pod_autoscaler_enabled"></a> [vertical\_pod\_autoscaler\_enabled](#input\_vertical\_pod\_autoscaler\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `string` | n/a | yes |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_windows_node_count"></a> [windows\_node\_count](#input\_windows\_node\_count) | Number of Windows nodes in the pool | `number` | `2` | no |
| <a name="input_windows_node_vm_size"></a> [windows\_node\_vm\_size](#input\_windows\_node\_vm\_size) | VM size for the Windows node pool | `string` | `"Standard_D4s_v3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_id"></a> [bastion\_host\_id](#output\_bastion\_host\_id) | ID of the Azure Bastion Host. |
| <a name="output_bastion_host_ip"></a> [bastion\_host\_ip](#output\_bastion\_host\_ip) | Public IP of the Azure Bastion Host. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | AKS cluster name. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kubeconfig for the AKS cluster. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group for the AKS cluster. |
| <a name="output_user_node_pool_id"></a> [user\_node\_pool\_id](#output\_user\_node\_pool\_id) | ID of the user node pool. |
| <a name="output_user_node_pool_name"></a> [user\_node\_pool\_name](#output\_user\_node\_pool\_name) | Name of the user node pool. |
| <a name="output_user_node_pool_vm_size"></a> [user\_node\_pool\_vm\_size](#output\_user\_node\_pool\_vm\_size) | VM size of the user node pool. |
| <a name="output_vm_nsg_id"></a> [vm\_nsg\_id](#output\_vm\_nsg\_id) | ID of the VM network security group |
<!-- END_TF_DOCS -->