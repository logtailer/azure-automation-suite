# 01-foundation

## Purpose
This component sets up the foundational Azure resources such as resource groups and storage accounts.

## Usage
- Edit `core.tfvars` with your values.
- Run `deploy.sh` or use Terraform CLI.

## Variables
- `resource_group_name`: Name of the resource group.
- `location`: Azure region.

## Outputs
- `resource_group_name`: The name of the created resource group.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_logger.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_api_management_named_value.env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_policy.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_policy) | resource |
| [azurerm_app_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration) | resource |
| [azurerm_cdn_frontdoor_endpoint.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_consumption_budget_resource_group.component_budget](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_consumption_budget_resource_group.component_budgets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_consumption_budget_subscription.anomaly_detection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |
| [azurerm_consumption_budget_subscription.platform_budget](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |
| [azurerm_container_registry.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_eventgrid_event_subscription.platform_servicebus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_event_subscription) | resource |
| [azurerm_eventgrid_topic.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_topic) | resource |
| [azurerm_log_analytics_saved_search.component_costs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_saved_search) | resource |
| [azurerm_log_analytics_workspace.cost_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_logic_app_action_http.notify_teams](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_action_http) | resource |
| [azurerm_logic_app_trigger_http_request.alert_webhook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_trigger_http_request) | resource |
| [azurerm_logic_app_workflow.alert_processor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow) | resource |
| [azurerm_monitor_action_group.cost_alerts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_notification_hub.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/notification_hub) | resource |
| [azurerm_notification_hub_namespace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/notification_hub_namespace) | resource |
| [azurerm_private_endpoint.app_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.component](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.app_config_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_servicebus_namespace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_queue.dead_letter](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue.platform_events](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_storage_account.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.artifacts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.backups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.component_state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_content_trust"></a> [acr\_content\_trust](#input\_acr\_content\_trust) | Enable content trust (image signing) on the ACR | `bool` | `false` | no |
| <a name="input_acr_geo_replications"></a> [acr\_geo\_replications](#input\_acr\_geo\_replications) | List of Azure regions to geo-replicate the ACR to (Premium only) | `list(string)` | `[]` | no |
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | Name of the Azure Container Registry (must be globally unique) | `string` | `""` | no |
| <a name="input_acr_private_only"></a> [acr\_private\_only](#input\_acr\_private\_only) | Disable public network access on the ACR (Premium only) | `bool` | `false` | no |
| <a name="input_acr_retention_days"></a> [acr\_retention\_days](#input\_acr\_retention\_days) | Number of days to retain untagged manifests | `number` | `30` | no |
| <a name="input_acr_sku"></a> [acr\_sku](#input\_acr\_sku) | ACR SKU: Basic, Standard, or Premium | `string` | `"Standard"` | no |
| <a name="input_apim_capacity"></a> [apim\_capacity](#input\_apim\_capacity) | Number of APIM scale units | `number` | `1` | no |
| <a name="input_apim_name"></a> [apim\_name](#input\_apim\_name) | Name of the API Management service (must be globally unique) | `string` | `""` | no |
| <a name="input_apim_publisher_email"></a> [apim\_publisher\_email](#input\_apim\_publisher\_email) | Publisher email for APIM notifications | `string` | `""` | no |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | Publisher name shown in the APIM developer portal | `string` | `"Platform Team"` | no |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | API Management SKU: Developer, Basic, Standard, or Premium | `string` | `"Developer"` | no |
| <a name="input_apim_subnet_id"></a> [apim\_subnet\_id](#input\_apim\_subnet\_id) | Subnet resource ID for APIM VNet injection (External or Internal mode) | `string` | `""` | no |
| <a name="input_apim_vnet_type"></a> [apim\_vnet\_type](#input\_apim\_vnet\_type) | APIM VNet integration type: None, External, or Internal | `string` | `"None"` | no |
| <a name="input_apns_bundle_id"></a> [apns\_bundle\_id](#input\_apns\_bundle\_id) | Apple APNs bundle ID for iOS push notifications | `string` | `""` | no |
| <a name="input_apns_key_id"></a> [apns\_key\_id](#input\_apns\_key\_id) | APNs authentication key ID | `string` | `""` | no |
| <a name="input_apns_production"></a> [apns\_production](#input\_apns\_production) | Use APNs production (true) or sandbox (false) endpoint | `bool` | `false` | no |
| <a name="input_apns_team_id"></a> [apns\_team\_id](#input\_apns\_team\_id) | Apple Developer Team ID | `string` | `""` | no |
| <a name="input_apns_token"></a> [apns\_token](#input\_apns\_token) | APNs authentication token content | `string` | `""` | no |
| <a name="input_app_config_name"></a> [app\_config\_name](#input\_app\_config\_name) | Name of the App Configuration store (must be globally unique) | `string` | `""` | no |
| <a name="input_app_config_private_endpoint_subnet_id"></a> [app\_config\_private\_endpoint\_subnet\_id](#input\_app\_config\_private\_endpoint\_subnet\_id) | Subnet ID for the App Configuration private endpoint | `string` | `""` | no |
| <a name="input_app_config_public_access"></a> [app\_config\_public\_access](#input\_app\_config\_public\_access) | Allow public network access to the App Configuration store | `bool` | `false` | no |
| <a name="input_app_config_reader_principal_ids"></a> [app\_config\_reader\_principal\_ids](#input\_app\_config\_reader\_principal\_ids) | Map of principal names to object IDs granted App Configuration Data Reader | `map(string)` | `{}` | no |
| <a name="input_app_config_sku"></a> [app\_config\_sku](#input\_app\_config\_sku) | App Configuration SKU: free or standard | `string` | `"standard"` | no |
| <a name="input_app_insights_instrumentation_key"></a> [app\_insights\_instrumentation\_key](#input\_app\_insights\_instrumentation\_key) | Application Insights instrumentation key for APIM logging | `string` | `""` | no |
| <a name="input_component_budget_amount"></a> [component\_budget\_amount](#input\_component\_budget\_amount) | Budget amount for individual component (if enabled) | `number` | `20` | no |
| <a name="input_component_budgets"></a> [component\_budgets](#input\_component\_budgets) | Budget configuration for each component type | <pre>map(object({<br/>    amount    = number<br/>    threshold = number<br/>  }))</pre> | <pre>{<br/>  "aks": {<br/>    "amount": 25,<br/>    "threshold": 80<br/>  },<br/>  "cicd": {<br/>    "amount": 2,<br/>    "threshold": 80<br/>  },<br/>  "foundation": {<br/>    "amount": 5,<br/>    "threshold": 80<br/>  },<br/>  "idp": {<br/>    "amount": 5,<br/>    "threshold": 80<br/>  },<br/>  "networking": {<br/>    "amount": 10,<br/>    "threshold": 80<br/>  },<br/>  "observability": {<br/>    "amount": 5,<br/>    "threshold": 80<br/>  },<br/>  "security": {<br/>    "amount": 3,<br/>    "threshold": 80<br/>  }<br/>}</pre> | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | Name of the component (used for container name) | `string` | n/a | yes |
| <a name="input_cost_alert_emails"></a> [cost\_alert\_emails](#input\_cost\_alert\_emails) | List of email addresses to receive cost alerts | `list(string)` | `[]` | no |
| <a name="input_cost_alert_threshold_1"></a> [cost\_alert\_threshold\_1](#input\_cost\_alert\_threshold\_1) | First cost alert threshold percentage (e.g., 50 for 50%) | `number` | `50` | no |
| <a name="input_cost_alert_threshold_2"></a> [cost\_alert\_threshold\_2](#input\_cost\_alert\_threshold\_2) | Second cost alert threshold percentage (e.g., 80 for 80%) | `number` | `80` | no |
| <a name="input_cost_alert_threshold_3"></a> [cost\_alert\_threshold\_3](#input\_cost\_alert\_threshold\_3) | Third cost alert threshold percentage (e.g., 100 for 100%) | `number` | `100` | no |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Data classification level for compliance tagging (public, internal, confidential) | `string` | `"internal"` | no |
| <a name="input_enable_acr"></a> [enable\_acr](#input\_enable\_acr) | Deploy an Azure Container Registry for private image storage | `bool` | `false` | no |
| <a name="input_enable_apim"></a> [enable\_apim](#input\_enable\_apim) | Deploy an Azure API Management instance | `bool` | `false` | no |
| <a name="input_enable_app_config"></a> [enable\_app\_config](#input\_enable\_app\_config) | Deploy an Azure App Configuration store for centralised feature flags and settings | `bool` | `false` | no |
| <a name="input_enable_component_budget"></a> [enable\_component\_budget](#input\_enable\_component\_budget) | Whether to create a separate budget for this specific component | `bool` | `false` | no |
| <a name="input_enable_event_grid"></a> [enable\_event\_grid](#input\_enable\_event\_grid) | Deploy an Event Grid topic with CloudEvents schema for platform event routing | `bool` | `false` | no |
| <a name="input_enable_front_door"></a> [enable\_front\_door](#input\_enable\_front\_door) | Deploy Azure Front Door (CDN Frontdoor) profile and endpoint | `bool` | `false` | no |
| <a name="input_enable_logic_app"></a> [enable\_logic\_app](#input\_enable\_logic\_app) | Deploy a Logic App workflow to process and route Azure Monitor alerts | `bool` | `false` | no |
| <a name="input_enable_notification_hub"></a> [enable\_notification\_hub](#input\_enable\_notification\_hub) | Deploy an Azure Notification Hub namespace for push notifications | `bool` | `false` | no |
| <a name="input_enable_platform_storage"></a> [enable\_platform\_storage](#input\_enable\_platform\_storage) | Deploy a platform storage account for artifacts and backups | `bool` | `false` | no |
| <a name="input_enable_service_bus"></a> [enable\_service\_bus](#input\_enable\_service\_bus) | Deploy an Azure Service Bus namespace with platform event queues | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_front_door_sku"></a> [front\_door\_sku](#input\_front\_door\_sku) | Front Door SKU: Standard\_AzureFrontDoor or Premium\_AzureFrontDoor | `string` | `"Standard_AzureFrontDoor"` | no |
| <a name="input_gcm_api_key"></a> [gcm\_api\_key](#input\_gcm\_api\_key) | Google Firebase Cloud Messaging API key for Android push notifications | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the resource group | `string` | n/a | yes |
| <a name="input_monthly_budget_amount"></a> [monthly\_budget\_amount](#input\_monthly\_budget\_amount) | Monthly budget amount in USD for cost monitoring | `number` | `100` | no |
| <a name="input_notification_hub_sku"></a> [notification\_hub\_sku](#input\_notification\_hub\_sku) | Notification Hub namespace SKU: Free, Basic, or Standard | `string` | `"Free"` | no |
| <a name="input_platform_storage_account_name"></a> [platform\_storage\_account\_name](#input\_platform\_storage\_account\_name) | Name of the platform storage account (must be globally unique) | `string` | `""` | no |
| <a name="input_platform_storage_replication"></a> [platform\_storage\_replication](#input\_platform\_storage\_replication) | Storage replication type: LRS, ZRS, GRS, GZRS | `string` | `"ZRS"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group for component resources | `string` | n/a | yes |
| <a name="input_service_bus_capacity"></a> [service\_bus\_capacity](#input\_service\_bus\_capacity) | Messaging units for Premium SKU (1, 2, 4, 8, or 16) | `number` | `1` | no |
| <a name="input_service_bus_namespace_name"></a> [service\_bus\_namespace\_name](#input\_service\_bus\_namespace\_name) | Name of the Service Bus namespace | `string` | `""` | no |
| <a name="input_service_bus_sku"></a> [service\_bus\_sku](#input\_service\_bus\_sku) | Service Bus SKU: Basic, Standard, or Premium | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_teams_webhook_url"></a> [teams\_webhook\_url](#input\_teams\_webhook\_url) | Microsoft Teams incoming webhook URL for alert notifications | `string` | `""` | no |
| <a name="input_tfstate_resource_group_name"></a> [tfstate\_resource\_group\_name](#input\_tfstate\_resource\_group\_name) | Name of the resource group for terraform state storage | `string` | n/a | yes |
| <a name="input_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#input\_tfstate\_storage\_account\_name) | Name of the Azure Storage Account for terraform state | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anomaly_detection_enabled"></a> [anomaly\_detection\_enabled](#output\_anomaly\_detection\_enabled) | Whether anomaly detection is enabled for this component |
| <a name="output_budget_amount"></a> [budget\_amount](#output\_budget\_amount) | Monthly budget amount configured |
| <a name="output_component_container_name"></a> [component\_container\_name](#output\_component\_container\_name) | Name of the component's state container |
| <a name="output_component_resource_group_id"></a> [component\_resource\_group\_id](#output\_component\_resource\_group\_id) | ID of the component resource group |
| <a name="output_component_resource_group_location"></a> [component\_resource\_group\_location](#output\_component\_resource\_group\_location) | Location of the component resource group |
| <a name="output_component_resource_group_name"></a> [component\_resource\_group\_name](#output\_component\_resource\_group\_name) | Name of the component resource group |
| <a name="output_cost_alert_emails"></a> [cost\_alert\_emails](#output\_cost\_alert\_emails) | Email addresses configured for cost alerts |
| <a name="output_platform_budget_id"></a> [platform\_budget\_id](#output\_platform\_budget\_id) | ID of the platform-wide budget |
| <a name="output_tfstate_resource_group_name"></a> [tfstate\_resource\_group\_name](#output\_tfstate\_resource\_group\_name) | Name of the terraform state resource group |
| <a name="output_tfstate_storage_account_id"></a> [tfstate\_storage\_account\_id](#output\_tfstate\_storage\_account\_id) | ID of the terraform state storage account |
| <a name="output_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#output\_tfstate\_storage\_account\_name) | Name of the terraform state storage account |
<!-- END_TF_DOCS -->