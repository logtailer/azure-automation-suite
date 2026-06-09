<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.baseline](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_policy_definition.audit_keyvault_soft_delete](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_classic_resources](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_non_compliant_location](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_public_ip_on_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_public_redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_public_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_ssh_rdp_from_internet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_unapproved_vm_skus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_unencrypted_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.require_cost_centre_tag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.require_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.require_https_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.require_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.require_tags](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.platform_baseline](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |
| [azurerm_resource_group_policy_exemption.legacy_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_exemption) | resource |
| [azurerm_resource_policy_exemption.dev_vm_sku](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_exemption) | resource |
| [azurerm_subscription_policy_assignment.baseline](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_remediation.require_https_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_remediation) | resource |
| [azurerm_subscription_policy_remediation.require_tags](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_remediation) | resource |
| [azurerm_management_group.root](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_at_management_group"></a> [assign\_at\_management\_group](#input\_assign\_at\_management\_group) | Assign the policy set at the management group level instead of subscription | `bool` | `false` | no |
| <a name="input_create_dev_sku_exemption"></a> [create\_dev\_sku\_exemption](#input\_create\_dev\_sku\_exemption) | Create a policy exemption for a development VM with non-standard SKU | `bool` | `false` | no |
| <a name="input_create_legacy_rg_exemption"></a> [create\_legacy\_rg\_exemption](#input\_create\_legacy\_rg\_exemption) | Create a policy exemption for a legacy resource group migrating to new tagging | `bool` | `false` | no |
| <a name="input_dev_exemption_expiry"></a> [dev\_exemption\_expiry](#input\_dev\_exemption\_expiry) | Expiry date for the dev VM SKU exemption (RFC3339) | `string` | `"2026-12-31T00:00:00Z"` | no |
| <a name="input_dev_exemption_ticket_ref"></a> [dev\_exemption\_ticket\_ref](#input\_dev\_exemption\_ticket\_ref) | Ticket reference for the dev VM SKU exemption approval | `string` | `""` | no |
| <a name="input_dev_vm_resource_id"></a> [dev\_vm\_resource\_id](#input\_dev\_vm\_resource\_id) | Resource ID of the development VM to exempt from VM SKU policy | `string` | `""` | no |
| <a name="input_enforce_policies"></a> [enforce\_policies](#input\_enforce\_policies) | Set to true to enforce policies (false = audit only) | `bool` | `false` | no |
| <a name="input_legacy_exemption_expiry"></a> [legacy\_exemption\_expiry](#input\_legacy\_exemption\_expiry) | Expiry date for the legacy RG tagging exemption (RFC3339) | `string` | `"2026-09-30T00:00:00Z"` | no |
| <a name="input_legacy_resource_group_id"></a> [legacy\_resource\_group\_id](#input\_legacy\_resource\_group\_id) | Resource group resource ID to exempt from tagging policy | `string` | `""` | no |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | Management group ID to assign policies to when assign\_at\_management\_group is true | `string` | `""` | no |
| <a name="input_non_compliance_message"></a> [non\_compliance\_message](#input\_non\_compliance\_message) | Custom non-compliance message shown when a resource violates a policy | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->