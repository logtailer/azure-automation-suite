# 03-Security Module

## Overview
Enterprise-grade security infrastructure providing centralized identity management, secrets storage, network security, governance, and audit logging for the Azure platform.

## Features

### Core Security
- Azure Key Vault (Standard/Premium)
- 4 Managed Identities (AKS, App, DevOps, Monitoring)
- RBAC role assignments
- Network Security Groups

### Governance
- Resource locks (CanNotDelete/ReadOnly)
- 6 Azure Policy assignments
- Tag enforcement
- Compliance monitoring

### Monitoring
- Key Vault diagnostic logging
- 3 availability/performance alerts
- Log Analytics integration
- Audit trail

## Quick Start

```bash
cd terraform/03-security
./deploy.sh production.tfvars
```

## Configuration

### Required Variables
- `resource_group_name`: Security resource group
- `key_vault_name`: Unique Key Vault name

### Optional Features
```hcl
enable_aks_identity        = true  # Managed identity for AKS
enable_private_endpoint    = false # Key Vault private endpoint
enable_resource_locks      = true  # Prevent deletion
enable_audit_logging       = true  # Diagnostic logs
enable_component_budget    = true  # Cost tracking
```

## Security Best Practices
- Enable purge protection (90-day retention)
- Use default deny for network ACLs
- Enable RBAC authorization
- Configure audit logging
- Set resource locks

## Outputs
- `key_vault_id`: Key Vault resource ID
- `aks_workload_identity_id`: Managed identity for AKS
- `app_workload_identity_id`: Managed identity for apps
- `security_nsg_id`: Network security group ID

## Documentation
- [Security Guide](SECURITY_GUIDE.md) - Comprehensive configuration guide
- [Foundation Module](../01-foundation/) - Base infrastructure
- [Observability Module](../05-observability/) - Monitoring integration

## Cost
**Estimated**: $10-15/month
- Key Vault: $0.03/10,000 operations
- Managed Identities: Free
- Diagnostic Logs: ~$2.50/GB

## Compliance
- CIS Azure Foundations Benchmark
- Azure Security Benchmark
- NIST SP 800-53
- ISO 27001

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.jit_policy](https://registry.terraform.io/providers/hashicorp/azapi/latest/docs/resources/resource) | resource |
| [azurerm_consumption_budget_resource_group.security_budget](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_federated_identity_credential.aks_workload](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_firewall.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.application_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.network_restricted](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.platform_tls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.ssl_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_key.platform_cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.ssh_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_solution.sentinel](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_management_lock.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_diagnostic_setting.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault_audit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.cert_expiry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.keyvault_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.keyvault_failed_requests](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.keyvault_saturation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.break_glass_signin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.mfa_disabled_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.privileged_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_network_security_group.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_https](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_all_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group_policy_assignment.audit_kv_purge](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.block_kv_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.defender_keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.require_https](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.require_tags](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_role_assignment.aks_kv_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_kv_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.break_glass_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.custom_workload_roles](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.devops_kv_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.monitoring_resource_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.privileged_group_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.workload_kv_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.aks_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.secret_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_security_center_auto_provisioning.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_auto_provisioning) | resource |
| [azurerm_security_center_contact.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_contact) | resource |
| [azurerm_security_center_server_vulnerability_assessment_virtual_machine.jit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_server_vulnerability_assessment_virtual_machine) | resource |
| [azurerm_security_center_subscription_pricing.app_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.sql_server_vms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.sql_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_subscription_pricing.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_workspace) | resource |
| [azurerm_sentinel_alert_rule_scheduled.admin_account_created](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_alert_rule_scheduled) | resource |
| [azurerm_sentinel_alert_rule_scheduled.brute_force_attempt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_alert_rule_scheduled) | resource |
| [azurerm_sentinel_data_connector_azure_active_directory.aad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_azure_active_directory) | resource |
| [azurerm_sentinel_data_connector_azure_security_center.asc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_azure_security_center) | resource |
| [azurerm_user_assigned_identity.aks_workload](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.app_workload](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.devops](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.workload](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_subscription.current_security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.observability](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_id"></a> [action\_group\_id](#input\_action\_group\_id) | Action group ID for alert notifications | `string` | `""` | no |
| <a name="input_aks_oidc_issuer_url"></a> [aks\_oidc\_issuer\_url](#input\_aks\_oidc\_issuer\_url) | OIDC issuer URL from the AKS cluster for federated identity binding | `string` | `""` | no |
| <a name="input_alert_notifications_enabled"></a> [alert\_notifications\_enabled](#input\_alert\_notifications\_enabled) | Enable alert notifications to security contact | `bool` | `true` | no |
| <a name="input_alerts_to_admins_enabled"></a> [alerts\_to\_admins\_enabled](#input\_alerts\_to\_admins\_enabled) | Send alerts to subscription admins | `bool` | `true` | no |
| <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges) | List of allowed IP ranges for Key Vault access | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_auto_provision_log_analytics"></a> [auto\_provision\_log\_analytics](#input\_auto\_provision\_log\_analytics) | Auto-provision Log Analytics agent on VMs | `bool` | `true` | no |
| <a name="input_break_glass_principal_id"></a> [break\_glass\_principal\_id](#input\_break\_glass\_principal\_id) | Object ID of the break-glass emergency account | `string` | `""` | no |
| <a name="input_break_glass_upn_fragment"></a> [break\_glass\_upn\_fragment](#input\_break\_glass\_upn\_fragment) | UPN fragment (partial match) of the break-glass account for sign-in alerting | `string` | `"breakglass"` | no |
| <a name="input_component_budget_amount"></a> [component\_budget\_amount](#input\_component\_budget\_amount) | Budget amount for this component in USD | `number` | `10` | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | Name of the component | `string` | `"security"` | no |
| <a name="input_cost_alert_emails"></a> [cost\_alert\_emails](#input\_cost\_alert\_emails) | List of email addresses for cost alerts | `list(string)` | `[]` | no |
| <a name="input_cost_alert_threshold"></a> [cost\_alert\_threshold](#input\_cost\_alert\_threshold) | Cost alert threshold percentage | `number` | `80` | no |
| <a name="input_critical_action_group_id"></a> [critical\_action\_group\_id](#input\_critical\_action\_group\_id) | Resource ID of the critical action group for security alerts | `string` | `""` | no |
| <a name="input_custom_role_assignments"></a> [custom\_role\_assignments](#input\_custom\_role\_assignments) | Map of custom role assignments for specific workloads | <pre>map(object({<br/>    scope        = string<br/>    role         = string<br/>    principal_id = string<br/>  }))</pre> | `{}` | no |
| <a name="input_default_network_action"></a> [default\_network\_action](#input\_default\_network\_action) | Default action for Key Vault network ACLs | `string` | `"Allow"` | no |
| <a name="input_defender_tier_app_service"></a> [defender\_tier\_app\_service](#input\_defender\_tier\_app\_service) | Defender tier for App Services | `string` | `"Standard"` | no |
| <a name="input_defender_tier_containers"></a> [defender\_tier\_containers](#input\_defender\_tier\_containers) | Defender tier for Containers (AKS) | `string` | `"Standard"` | no |
| <a name="input_defender_tier_key_vault"></a> [defender\_tier\_key\_vault](#input\_defender\_tier\_key\_vault) | Defender tier for Key Vault | `string` | `"Standard"` | no |
| <a name="input_defender_tier_servers"></a> [defender\_tier\_servers](#input\_defender\_tier\_servers) | Defender tier for Virtual Machines (Free or Standard) | `string` | `"Standard"` | no |
| <a name="input_defender_tier_sql"></a> [defender\_tier\_sql](#input\_defender\_tier\_sql) | Defender tier for SQL Databases | `string` | `"Standard"` | no |
| <a name="input_defender_tier_sql_vms"></a> [defender\_tier\_sql\_vms](#input\_defender\_tier\_sql\_vms) | Defender tier for SQL Server VMs | `string` | `"Standard"` | no |
| <a name="input_defender_tier_storage"></a> [defender\_tier\_storage](#input\_defender\_tier\_storage) | Defender tier for Storage Accounts | `string` | `"Standard"` | no |
| <a name="input_enable_aks_identity"></a> [enable\_aks\_identity](#input\_enable\_aks\_identity) | Create managed identity for AKS workloads | `bool` | `true` | no |
| <a name="input_enable_app_identity"></a> [enable\_app\_identity](#input\_enable\_app\_identity) | Create managed identity for application workloads | `bool` | `true` | no |
| <a name="input_enable_audit_logging"></a> [enable\_audit\_logging](#input\_enable\_audit\_logging) | Enable audit logging for Key Vault | `bool` | `true` | no |
| <a name="input_enable_break_glass"></a> [enable\_break\_glass](#input\_enable\_break\_glass) | Assign Owner to a break-glass account and alert on sign-in | `bool` | `false` | no |
| <a name="input_enable_component_budget"></a> [enable\_component\_budget](#input\_enable\_component\_budget) | Whether to create a budget for this component | `bool` | `true` | no |
| <a name="input_enable_custom_aks_role"></a> [enable\_custom\_aks\_role](#input\_enable\_custom\_aks\_role) | Create a custom AKS Operator role definition scoped to the subscription | `bool` | `false` | no |
| <a name="input_enable_custom_secret_role"></a> [enable\_custom\_secret\_role](#input\_enable\_custom\_secret\_role) | Create a custom Secret Reader role definition for Key Vault read-only access | `bool` | `false` | no |
| <a name="input_enable_customer_managed_key"></a> [enable\_customer\_managed\_key](#input\_enable\_customer\_managed\_key) | Create a customer-managed RSA key in Key Vault with automatic 365-day rotation | `bool` | `false` | no |
| <a name="input_enable_defender_policy"></a> [enable\_defender\_policy](#input\_enable\_defender\_policy) | Enable policy to require Azure Defender for Key Vault | `bool` | `false` | no |
| <a name="input_enable_devops_identity"></a> [enable\_devops\_identity](#input\_enable\_devops\_identity) | Create managed identity for DevOps automation | `bool` | `true` | no |
| <a name="input_enable_firewall"></a> [enable\_firewall](#input\_enable\_firewall) | Enable Azure Firewall | `bool` | `true` | no |
| <a name="input_enable_https_policy"></a> [enable\_https\_policy](#input\_enable\_https\_policy) | Enable policy to require HTTPS for storage | `bool` | `true` | no |
| <a name="input_enable_jit_access"></a> [enable\_jit\_access](#input\_enable\_jit\_access) | Create a Defender for Cloud Just-in-Time access policy for SSH and RDP | `bool` | `false` | no |
| <a name="input_enable_kv_alerts"></a> [enable\_kv\_alerts](#input\_enable\_kv\_alerts) | Enable monitoring alerts for Key Vault | `bool` | `true` | no |
| <a name="input_enable_kv_network_restriction"></a> [enable\_kv\_network\_restriction](#input\_enable\_kv\_network\_restriction) | Enable network restrictions on Key Vault | `bool` | `false` | no |
| <a name="input_enable_kv_private_endpoint"></a> [enable\_kv\_private\_endpoint](#input\_enable\_kv\_private\_endpoint) | Create a private endpoint for Key Vault to restrict access to the VNet | `bool` | `false` | no |
| <a name="input_enable_kv_public_block_policy"></a> [enable\_kv\_public\_block\_policy](#input\_enable\_kv\_public\_block\_policy) | Enable policy to block public network access to Key Vault | `bool` | `false` | no |
| <a name="input_enable_kv_purge_policy"></a> [enable\_kv\_purge\_policy](#input\_enable\_kv\_purge\_policy) | Enable policy to audit Key Vaults without purge protection | `bool` | `true` | no |
| <a name="input_enable_mfa_alerts"></a> [enable\_mfa\_alerts](#input\_enable\_mfa\_alerts) | Alert when MFA is disabled for any user account via Entra audit logs | `bool` | `false` | no |
| <a name="input_enable_monitoring_identity"></a> [enable\_monitoring\_identity](#input\_enable\_monitoring\_identity) | Create managed identity for monitoring services | `bool` | `true` | no |
| <a name="input_enable_network_security"></a> [enable\_network\_security](#input\_enable\_network\_security) | Enable network security group for security resources | `bool` | `true` | no |
| <a name="input_enable_pim_alerts"></a> [enable\_pim\_alerts](#input\_enable\_pim\_alerts) | Alert on new Owner or User Access Administrator role assignments | `bool` | `false` | no |
| <a name="input_enable_pim_group"></a> [enable\_pim\_group](#input\_enable\_pim\_group) | Create a Contributor role assignment for a PIM-managed privileged access group | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Enable private endpoint for Key Vault | `bool` | `false` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Enable RBAC authorization for Key Vault | `bool` | `true` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | Enable resource locks on critical resources | `bool` | `true` | no |
| <a name="input_enable_rg_lock"></a> [enable\_rg\_lock](#input\_enable\_rg\_lock) | Enable resource lock on security resource group | `bool` | `false` | no |
| <a name="input_enable_sentinel_aad_connector"></a> [enable\_sentinel\_aad\_connector](#input\_enable\_sentinel\_aad\_connector) | Enable Azure Active Directory data connector for Sentinel | `bool` | `true` | no |
| <a name="input_enable_sentinel_alert_rules"></a> [enable\_sentinel\_alert\_rules](#input\_enable\_sentinel\_alert\_rules) | Enable pre-configured Sentinel alert rules | `bool` | `true` | no |
| <a name="input_enable_sentinel_asc_connector"></a> [enable\_sentinel\_asc\_connector](#input\_enable\_sentinel\_asc\_connector) | Enable Azure Security Center data connector for Sentinel | `bool` | `true` | no |
| <a name="input_enable_tag_policy"></a> [enable\_tag\_policy](#input\_enable\_tag\_policy) | Enable policy to require tags on resources | `bool` | `true` | no |
| <a name="input_enable_tls_certificate"></a> [enable\_tls\_certificate](#input\_enable\_tls\_certificate) | Create a self-signed TLS certificate in Key Vault with 30-day auto-renewal | `bool` | `false` | no |
| <a name="input_enable_workload_identity"></a> [enable\_workload\_identity](#input\_enable\_workload\_identity) | Create a user-assigned managed identity for workload identity federation | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Allow Azure VMs to retrieve certificates stored as secrets | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Allow Azure Disk Encryption to retrieve secrets and unwrap keys | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_firewall_intrusion_detection_mode"></a> [firewall\_intrusion\_detection\_mode](#input\_firewall\_intrusion\_detection\_mode) | Intrusion detection mode (Off, Alert, Deny) | `string` | `"Alert"` | no |
| <a name="input_firewall_sku_name"></a> [firewall\_sku\_name](#input\_firewall\_sku\_name) | SKU name for Azure Firewall | `string` | `"AZFW_VNet"` | no |
| <a name="input_firewall_sku_tier"></a> [firewall\_sku\_tier](#input\_firewall\_sku\_tier) | SKU tier for Azure Firewall (Standard or Premium) | `string` | `"Standard"` | no |
| <a name="input_jit_target_vm_id"></a> [jit\_target\_vm\_id](#input\_jit\_target\_vm\_id) | Resource ID of the VM to protect with JIT access | `string` | `""` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the Azure Key Vault | `string` | n/a | yes |
| <a name="input_key_vault_private_endpoint_subnet_id"></a> [key\_vault\_private\_endpoint\_subnet\_id](#input\_key\_vault\_private\_endpoint\_subnet\_id) | Subnet ID for Key Vault private endpoint | `string` | `""` | no |
| <a name="input_key_vault_sku"></a> [key\_vault\_sku](#input\_key\_vault\_sku) | SKU name for the Key Vault | `string` | `"standard"` | no |
| <a name="input_kv_private_dns_zone_id"></a> [kv\_private\_dns\_zone\_id](#input\_kv\_private\_dns\_zone\_id) | Resource ID of the privatelink.vaultcore.azure.net private DNS zone | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the resource group | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | Level of resource lock (CanNotDelete or ReadOnly) | `string` | `"CanNotDelete"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for diagnostic logs | `string` | `""` | no |
| <a name="input_pim_group_object_id"></a> [pim\_group\_object\_id](#input\_pim\_group\_object\_id) | Object ID of the Azure AD group used for privileged PIM access | `string` | `""` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for placing the Key Vault private endpoint | `string` | `""` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Enable purge protection | `bool` | `true` | no |
| <a name="input_purge_soft_delete_on_destroy"></a> [purge\_soft\_delete\_on\_destroy](#input\_purge\_soft\_delete\_on\_destroy) | Purge soft delete on destroy | `bool` | `false` | no |
| <a name="input_recover_soft_deleted_key_vaults"></a> [recover\_soft\_deleted\_key\_vaults](#input\_recover\_soft\_deleted\_key\_vaults) | Recover soft deleted key vaults | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group for this component | `string` | n/a | yes |
| <a name="input_security_contact_email"></a> [security\_contact\_email](#input\_security\_contact\_email) | Email address for security alerts | `string` | n/a | yes |
| <a name="input_security_contact_phone"></a> [security\_contact\_phone](#input\_security\_contact\_phone) | Phone number for security contact | `string` | `""` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of days to retain deleted items | `number` | `90` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for VM access | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID for private endpoint (required if enable\_private\_endpoint is true) | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_tfstate_resource_group_name"></a> [tfstate\_resource\_group\_name](#input\_tfstate\_resource\_group\_name) | Name of the resource group for terraform state storage | `string` | `"terraform-state-rg"` | no |
| <a name="input_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#input\_tfstate\_storage\_account\_name) | Name of the Azure Storage Account for terraform state | `string` | `"sumittfstatestorage"` | no |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | VNet ID for private DNS zone link (required if enable\_private\_endpoint is true) | `string` | `""` | no |
| <a name="input_workload_namespace"></a> [workload\_namespace](#input\_workload\_namespace) | Kubernetes namespace of the service account to federate | `string` | `"default"` | no |
| <a name="input_workload_service_account"></a> [workload\_service\_account](#input\_workload\_service\_account) | Kubernetes service account name to federate with the managed identity | `string` | `"workload-sa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_workload_identity_client_id"></a> [aks\_workload\_identity\_client\_id](#output\_aks\_workload\_identity\_client\_id) | Client ID of the AKS workload managed identity |
| <a name="output_aks_workload_identity_id"></a> [aks\_workload\_identity\_id](#output\_aks\_workload\_identity\_id) | ID of the AKS workload managed identity |
| <a name="output_app_workload_identity_id"></a> [app\_workload\_identity\_id](#output\_app\_workload\_identity\_id) | ID of the application workload managed identity |
| <a name="output_devops_identity_id"></a> [devops\_identity\_id](#output\_devops\_identity\_id) | ID of the DevOps automation managed identity |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | ID of the Azure Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Azure Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Azure Key Vault |
| <a name="output_keyvault_private_endpoint_ip"></a> [keyvault\_private\_endpoint\_ip](#output\_keyvault\_private\_endpoint\_ip) | Private IP address of Key Vault private endpoint |
| <a name="output_monitoring_identity_id"></a> [monitoring\_identity\_id](#output\_monitoring\_identity\_id) | ID of the monitoring managed identity |
| <a name="output_security_nsg_id"></a> [security\_nsg\_id](#output\_security\_nsg\_id) | ID of the security network security group |
| <a name="output_ssh_public_key_secret_id"></a> [ssh\_public\_key\_secret\_id](#output\_ssh\_public\_key\_secret\_id) | ID of the SSH public key secret in Key Vault |
<!-- END_TF_DOCS -->
