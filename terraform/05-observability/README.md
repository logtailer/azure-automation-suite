# 05-Observability Module

## Overview
Comprehensive observability solution providing centralized logging, metrics visualization, and proactive alerting for the Azure platform.

## Features

### Core Monitoring
- Log Analytics Workspace (30-day retention)
- Application Insights
- Azure Managed Grafana
- Azure Monitor Prometheus

### Infrastructure Monitoring
- AKS cluster health
- Storage availability
- Application performance

### IDP (Backstage) Monitoring
- Container Instance metrics (CPU, memory, restarts)
- PostgreSQL performance (CPU, memory, storage, connections)
- Container Registry activity
- Diagnostic logs integration

## Quick Start

### Deployment
```bash
cd terraform/05-observability
./deploy.sh production.tfvars
```

### Access Grafana
```bash
terraform output grafana_url
```

## Configuration

### Required Variables
- `resource_group_name`: Resource group name
- `admin_email`: Email for alert notifications

### Optional Features
```hcl
enable_idp_monitoring     = true  # Monitor Backstage/IDP
enable_prometheus_metrics = true  # Enable Prometheus workspace
```

## Documentation
- [Monitoring Guide](MONITORING_GUIDE.md) - Comprehensive setup and usage
- [Foundation Module](../01-foundation/) - Base infrastructure
- [IDP Module](../07-idp/) - Backstage platform

## Outputs
- `grafana_url`: Grafana dashboard URL
- `log_analytics_workspace_id`: Log Analytics workspace ID
- `application_insights_instrumentation_key`: App Insights key (sensitive)

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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights_smart_detection_rule.failure_anomalies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_smart_detection_rule) | resource |
| [azurerm_application_insights_smart_detection_rule.slow_requests](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_smart_detection_rule) | resource |
| [azurerm_application_insights_web_test.platform_api_ping](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) | resource |
| [azurerm_application_insights_workbook.api_health](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) | resource |
| [azurerm_application_insights_workbook.cost_overview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) | resource |
| [azurerm_application_insights_workbook.platform_overview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) | resource |
| [azurerm_consumption_budget_resource_group.component_budget](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_consumption_budget_subscription.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |
| [azurerm_dashboard_grafana.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dashboard_grafana) | resource |
| [azurerm_grafana_managed_private_endpoint.prometheus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/grafana_managed_private_endpoint) | resource |
| [azurerm_log_analytics_workspace.audit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.critical](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.pagerduty](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.warning](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_activity_log_alert.aci_restart](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_alert_processing_rule_action_group.route_critical](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_action_group) | resource |
| [azurerm_monitor_alert_processing_rule_suppression.maintenance_window](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_suppression) | resource |
| [azurerm_monitor_data_collection_endpoint.otel](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.otel](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule.prometheus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_monitor_diagnostic_setting.aci_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.acr_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.postgres_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.aci_cpu_usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aci_memory_usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_cpu_usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_memory_usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_node_cpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_node_health](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_node_memory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.aks_pod_failed](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.app_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.appgw_unhealthy_hosts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.availability_drop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.availability_slo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.critical_service_down](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.error_rate_slo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_connections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_cpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_memory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.response_time](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.storage_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.vnet_dropped_packets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.error_budget_burn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.high_error_rate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.kv_unauthorized_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.p99_latency](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_workspace.prometheus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_workspace) | resource |
| [azurerm_portal_dashboard.platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/portal_dashboard) | resource |
| [azurerm_role_assignment.grafana_data_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.grafana_idp_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.grafana_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [terraform_remote_state.idp](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_name"></a> [action\_group\_name](#input\_action\_group\_name) | Name of the monitor action group | `string` | `"alerts-actiongroup"` | no |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Admin email for alerts | `string` | n/a | yes |
| <a name="input_aks_cluster_id"></a> [aks\_cluster\_id](#input\_aks\_cluster\_id) | Resource ID of the AKS cluster to monitor | `string` | `""` | no |
| <a name="input_aks_cpu_alert_threshold"></a> [aks\_cpu\_alert\_threshold](#input\_aks\_cpu\_alert\_threshold) | CPU utilisation percentage threshold for AKS node alert | `number` | `80` | no |
| <a name="input_aks_memory_alert_threshold"></a> [aks\_memory\_alert\_threshold](#input\_aks\_memory\_alert\_threshold) | Memory working-set percentage threshold for AKS node alert | `number` | `80` | no |
| <a name="input_alert_evaluation_frequency"></a> [alert\_evaluation\_frequency](#input\_alert\_evaluation\_frequency) | How often metric alerts are evaluated (ISO 8601 duration) | `string` | `"PT5M"` | no |
| <a name="input_alert_window_size"></a> [alert\_window\_size](#input\_alert\_window\_size) | Window size for metric alert evaluation (ISO 8601 duration) | `string` | `"PT15M"` | no |
| <a name="input_apim_resource_id"></a> [apim\_resource\_id](#input\_apim\_resource\_id) | Resource ID of the API Management service for diagnostic settings | `string` | `""` | no |
| <a name="input_app_insights_retention_days"></a> [app\_insights\_retention\_days](#input\_app\_insights\_retention\_days) | Data retention in days for Application Insights (30–730) | `number` | `90` | no |
| <a name="input_app_insights_sampling_percentage"></a> [app\_insights\_sampling\_percentage](#input\_app\_insights\_sampling\_percentage) | Adaptive sampling percentage for Application Insights (0–100) | `number` | `100` | no |
| <a name="input_appgw_resource_id"></a> [appgw\_resource\_id](#input\_appgw\_resource\_id) | Resource ID of the Application Gateway to monitor for unhealthy backend hosts | `string` | `""` | no |
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Name of the Application Insights instance | `string` | `"appinsights-monitoring"` | no |
| <a name="input_audit_log_retention_days"></a> [audit\_log\_retention\_days](#input\_audit\_log\_retention\_days) | Retention in days for the audit Log Analytics workspace | `number` | `365` | no |
| <a name="input_azure_monitor_workspace_id"></a> [azure\_monitor\_workspace\_id](#input\_azure\_monitor\_workspace\_id) | Resource ID of the Azure Monitor workspace for Prometheus ingestion | `string` | `""` | no |
| <a name="input_component_budget_amount"></a> [component\_budget\_amount](#input\_component\_budget\_amount) | Budget amount for this component in USD | `number` | `20` | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | Name of the component (used for naming) | `string` | `"observability"` | no |
| <a name="input_cost_alert_emails"></a> [cost\_alert\_emails](#input\_cost\_alert\_emails) | List of email addresses to receive cost alerts | `list(string)` | `[]` | no |
| <a name="input_cost_alert_threshold"></a> [cost\_alert\_threshold](#input\_cost\_alert\_threshold) | Cost alert threshold percentage (e.g., 80 for 80%) | `number` | `80` | no |
| <a name="input_critical_alert_emails"></a> [critical\_alert\_emails](#input\_critical\_alert\_emails) | Map of name => email address for critical alert action group receivers | `map(string)` | `{}` | no |
| <a name="input_enable_aks_alerts"></a> [enable\_aks\_alerts](#input\_enable\_aks\_alerts) | Enable metric alerts for AKS node CPU, memory, and failed pods | `bool` | `false` | no |
| <a name="input_enable_alert_routing"></a> [enable\_alert\_routing](#input\_enable\_alert\_routing) | Create an alert processing rule to route Sev0-1 alerts to the on-call action group | `bool` | `false` | no |
| <a name="input_enable_apim_diagnostics"></a> [enable\_apim\_diagnostics](#input\_enable\_apim\_diagnostics) | Send APIM gateway logs to Log Analytics | `bool` | `false` | no |
| <a name="input_enable_app_insights"></a> [enable\_app\_insights](#input\_enable\_app\_insights) | Deploy Application Insights workspace-based resource for APM | `bool` | `false` | no |
| <a name="input_enable_audit_workspace"></a> [enable\_audit\_workspace](#input\_enable\_audit\_workspace) | Create a dedicated Log Analytics workspace for audit logs | `bool` | `false` | no |
| <a name="input_enable_component_budget"></a> [enable\_component\_budget](#input\_enable\_component\_budget) | Whether to create a budget for this component | `bool` | `false` | no |
| <a name="input_enable_cost_budget"></a> [enable\_cost\_budget](#input\_enable\_cost\_budget) | Create an Azure consumption budget with 80%/100%/110% threshold alerts | `bool` | `false` | no |
| <a name="input_enable_data_collection_rule"></a> [enable\_data\_collection\_rule](#input\_enable\_data\_collection\_rule) | Create a data collection rule for platform-wide log aggregation | `bool` | `false` | no |
| <a name="input_enable_idp_monitoring"></a> [enable\_idp\_monitoring](#input\_enable\_idp\_monitoring) | Enable monitoring for IDP (Backstage) resources | `bool` | `false` | no |
| <a name="input_enable_kv_diagnostics"></a> [enable\_kv\_diagnostics](#input\_enable\_kv\_diagnostics) | Send Key Vault audit logs to Log Analytics | `bool` | `false` | no |
| <a name="input_enable_maintenance_suppression"></a> [enable\_maintenance\_suppression](#input\_enable\_maintenance\_suppression) | Create an alert processing rule to suppress Sev2-4 alerts during weekend maintenance windows | `bool` | `false` | no |
| <a name="input_enable_network_alerts"></a> [enable\_network\_alerts](#input\_enable\_network\_alerts) | Enable metric alerts for VNet dropped packets and Application Gateway unhealthy hosts | `bool` | `false` | no |
| <a name="input_enable_opsgenie_integration"></a> [enable\_opsgenie\_integration](#input\_enable\_opsgenie\_integration) | Enable OpsGenie integration for alerts | `bool` | `false` | no |
| <a name="input_enable_otel_collector"></a> [enable\_otel\_collector](#input\_enable\_otel\_collector) | Create an Azure Monitor data collection endpoint and rule for OpenTelemetry | `bool` | `false` | no |
| <a name="input_enable_pagerduty_integration"></a> [enable\_pagerduty\_integration](#input\_enable\_pagerduty\_integration) | Enable PagerDuty integration for alerts | `bool` | `false` | no |
| <a name="input_enable_prometheus_collection"></a> [enable\_prometheus\_collection](#input\_enable\_prometheus\_collection) | Create a data collection rule to forward Prometheus metrics to Azure Monitor workspace | `bool` | `false` | no |
| <a name="input_enable_prometheus_metrics"></a> [enable\_prometheus\_metrics](#input\_enable\_prometheus\_metrics) | Enable Azure Monitor Workspace for Prometheus-compatible metrics | `bool` | `false` | no |
| <a name="input_enable_slo_alerts"></a> [enable\_slo\_alerts](#input\_enable\_slo\_alerts) | Enable SLO-based error-budget burn and p99 latency alerts | `bool` | `false` | no |
| <a name="input_enable_storage_diagnostics"></a> [enable\_storage\_diagnostics](#input\_enable\_storage\_diagnostics) | Send storage account blob operation logs to Log Analytics | `bool` | `false` | no |
| <a name="input_enable_synthetic_monitor"></a> [enable\_synthetic\_monitor](#input\_enable\_synthetic\_monitor) | Create an Application Insights web test for synthetic availability monitoring | `bool` | `false` | no |
| <a name="input_enable_workbooks"></a> [enable\_workbooks](#input\_enable\_workbooks) | Create Application Insights workbooks for API health and cost overview | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, prod, etc.) | `string` | `"production"` | no |
| <a name="input_grafana_name"></a> [grafana\_name](#input\_grafana\_name) | Name of the Grafana dashboard | `string` | `"grafana-monitoring"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Resource ID of the Key Vault to capture diagnostic logs from | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the resource group | `string` | n/a | yes |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | SKU for Log Analytics workspace | `string` | `"PerGB2018"` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the Log Analytics workspace | `string` | `"law-monitoring"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain logs | `number` | `30` | no |
| <a name="input_monthly_budget_amount"></a> [monthly\_budget\_amount](#input\_monthly\_budget\_amount) | Monthly budget amount in USD for the subscription cost alert | `number` | `1000` | no |
| <a name="input_opsgenie_webhook_url"></a> [opsgenie\_webhook\_url](#input\_opsgenie\_webhook\_url) | OpsGenie webhook URL for alert notifications | `string` | `""` | no |
| <a name="input_pagerduty_webhook_url"></a> [pagerduty\_webhook\_url](#input\_pagerduty\_webhook\_url) | PagerDuty webhook URL for alert notifications | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group for this component | `string` | n/a | yes |
| <a name="input_slo_error_rate_threshold"></a> [slo\_error\_rate\_threshold](#input\_slo\_error\_rate\_threshold) | Error rate fraction (0–1) that triggers the fast-burn alert | `number` | `0.01` | no |
| <a name="input_slo_latency_p99_ms"></a> [slo\_latency\_p99\_ms](#input\_slo\_latency\_p99\_ms) | p99 latency threshold in milliseconds for the latency SLO alert | `number` | `500` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Resource ID of the storage account for diagnostic settings | `string` | `""` | no |
| <a name="input_synthetic_monitor_url"></a> [synthetic\_monitor\_url](#input\_synthetic\_monitor\_url) | URL to ping for the synthetic availability monitor | `string` | `"https://api.platform.example.com/health"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_tfstate_resource_group_name"></a> [tfstate\_resource\_group\_name](#input\_tfstate\_resource\_group\_name) | Name of the resource group for terraform state storage | `string` | `"terraform-state-rg"` | no |
| <a name="input_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#input\_tfstate\_storage\_account\_name) | Name of the Azure Storage Account for terraform state | `string` | `"sumittfstatestorage"` | no |
| <a name="input_vnet_resource_id"></a> [vnet\_resource\_id](#input\_vnet\_resource\_id) | Resource ID of the VNet to monitor for dropped packets | `string` | `""` | no |
| <a name="input_warning_alert_emails"></a> [warning\_alert\_emails](#input\_warning\_alert\_emails) | Map of name => email address for warning alert action group receivers | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_group_id"></a> [action\_group\_id](#output\_action\_group\_id) | ID of the monitor action group |
| <a name="output_application_insights_connection_string"></a> [application\_insights\_connection\_string](#output\_application\_insights\_connection\_string) | Connection string for Application Insights |
| <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id) | ID of the Application Insights instance |
| <a name="output_application_insights_instrumentation_key"></a> [application\_insights\_instrumentation\_key](#output\_application\_insights\_instrumentation\_key) | Instrumentation key for Application Insights |
| <a name="output_grafana_id"></a> [grafana\_id](#output\_grafana\_id) | Resource ID of the Grafana dashboard |
| <a name="output_grafana_url"></a> [grafana\_url](#output\_grafana\_url) | URL for accessing Grafana dashboard |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | ID of the Log Analytics workspace |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Name of the Log Analytics workspace |
<!-- END_TF_DOCS -->
