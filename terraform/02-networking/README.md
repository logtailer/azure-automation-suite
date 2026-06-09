# Networking Module

This module creates the core networking infrastructure for the Azure DevOps platform, including:

- Virtual Network (VNet) with multiple subnets
- Public subnet for load balancers and ingress
- Private subnet for backend services
- AKS-dedicated subnet for Kubernetes cluster
- NAT Gateway for secure outbound connectivity
- Network Security Groups (NSGs) for traffic control

## Architecture

```
Azure DevOps Platform VNet (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24)
│   ├── Application Gateway
│   └── Load Balancers
├── Private Subnet (10.0.2.0/24)
│   ├── Private endpoints
│   └── Backend services
└── AKS Subnet (10.0.10.0/23)
    └── Kubernetes cluster nodes
```

## Usage

### Prerequisites
1. Foundation module must be deployed first
2. Terraform backend must be configured
3. Azure CLI authentication required

### Deployment

```bash
# Navigate to networking module
cd terraform/02-networking

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="../environments/dev/terraform.tfvars"

# Apply configuration
terraform apply -var-file="../environments/dev/terraform.tfvars"
```

### Required Variables

Create a `terraform.tfvars` file with these values:

```hcl
# Backend configuration
backend_resource_group_name  = "your-terraform-rg"
backend_storage_account_name = "yourtfstatestorage"

# Project configuration
environment  = "dev"


# Network configuration
vnet_name          = "devops-platform-vnet"
vnet_address_space = "10.0.0.0/16"

# Subnet configuration
public_subnet_name  = "public-subnet"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_name = "private-subnet"
private_subnet_cidr = "10.0.2.0/24"
aks_subnet_name     = "aks-subnet"
aks_subnet_cidr     = "10.0.10.0/23"
```

## Resources Created

### Core Networking
- **Virtual Network**: Main network container
- **Public Subnet**: Internet-facing resources
- **Private Subnet**: Internal resources with NAT Gateway
- **AKS Subnet**: Dedicated subnet for Kubernetes

### Security
- **NAT Gateway**: Secure outbound internet access
- **Public NSG**: HTTP/HTTPS traffic allowed
- **Private NSG**: VNet-only traffic allowed

### Outputs
- VNet ID and configuration details
- Subnet IDs for other modules to reference
- NAT Gateway public IP
- NSG IDs for additional rule configuration

## Dependencies

### Inputs (from foundation module)
- Resource group name and location
- Common tags and naming conventions

### Outputs (for other modules)
- AKS subnet ID → 04-aks module
- Private subnet ID → 03-security module
- VNet ID → Multiple modules

## Cost Optimization

- **NAT Gateway**: ~$45/month per gateway
- **Public IP**: ~$3.65/month per static IP
- **NSG**: Free with Azure subscription

## Security Features

- **Zero Trust**: Default deny, explicit allow rules
- **Subnet Isolation**: Separate subnets for different tiers
- **NAT Gateway**: No direct public IP on private resources
- **NSG Rules**: Least privilege access patterns

## Next Steps

After deploying networking:
1. Deploy security module (03-security)
2. Configure private endpoints
3. Deploy AKS cluster (04-aks)
4. Set up monitoring (05-observability)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_bastion_host.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_express_route_circuit.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_firewall.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.aks_egress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_monitor_diagnostic_setting.nsg_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_ddos_protection_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_network_security_group.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_watcher.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher) | resource |
| [azurerm_network_watcher_flow_log.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_network_watcher_flow_log.private_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_private_dns_resolver.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_outbound_endpoint) | resource |
| [azurerm_private_dns_zone.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_link_service.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_link_service) | resource |
| [azurerm_public_ip.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.er_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.nat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.vpn_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_route.internet_via_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.aci_delegated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.dns_resolver_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.dns_resolver_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.postgres_delegated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_traffic_manager_azure_endpoint.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_azure_endpoint) | resource |
| [azurerm_traffic_manager_azure_endpoint.secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_azure_endpoint) | resource |
| [azurerm_traffic_manager_profile.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile) | resource |
| [azurerm_virtual_network.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.er](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.er](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |
| [azurerm_virtual_network_peering.additional](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.hub_to_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_web_application_firewall_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) | resource |
| [azurerm_resource_group.foundation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_subnet_address_prefix"></a> [aci\_subnet\_address\_prefix](#input\_aci\_subnet\_address\_prefix) | Address prefix for the ACI delegated subnet | `list(string)` | <pre>[<br/>  "10.0.21.0/24"<br/>]</pre> | no |
| <a name="input_additional_vnet_peerings"></a> [additional\_vnet\_peerings](#input\_additional\_vnet\_peerings) | Map of additional VNet peerings (name -> remote VNet resource ID) | `map(string)` | `{}` | no |
| <a name="input_aks_private_dns_zone_name"></a> [aks\_private\_dns\_zone\_name](#input\_aks\_private\_dns\_zone\_name) | Private DNS zone name for AKS (e.g. privatelink.eastus.azmk8s.io) | `string` | `"privatelink.eastus.azmk8s.io"` | no |
| <a name="input_aks_subnet_address_prefixes"></a> [aks\_subnet\_address\_prefixes](#input\_aks\_subnet\_address\_prefixes) | Address prefixes for the AKS subnet | `list(string)` | <pre>[<br/>  "10.0.10.0/23"<br/>]</pre> | no |
| <a name="input_appgw_capacity"></a> [appgw\_capacity](#input\_appgw\_capacity) | Application Gateway instance count (1–125) | `number` | `2` | no |
| <a name="input_appgw_sku_name"></a> [appgw\_sku\_name](#input\_appgw\_sku\_name) | Application Gateway SKU name | `string` | `"Standard_v2"` | no |
| <a name="input_appgw_sku_tier"></a> [appgw\_sku\_tier](#input\_appgw\_sku\_tier) | Application Gateway SKU tier | `string` | `"Standard_v2"` | no |
| <a name="input_appgw_subnet_address_prefix"></a> [appgw\_subnet\_address\_prefix](#input\_appgw\_subnet\_address\_prefix) | Address prefix for the Application Gateway subnet (minimum /24) | `list(string)` | <pre>[<br/>  "10.0.230.0/24"<br/>]</pre> | no |
| <a name="input_bastion_subnet_prefix"></a> [bastion\_subnet\_prefix](#input\_bastion\_subnet\_prefix) | Address prefix for AzureBastionSubnet (must be /26 or larger) | `list(string)` | <pre>[<br/>  "10.0.250.0/26"<br/>]</pre> | no |
| <a name="input_custom_private_endpoints"></a> [custom\_private\_endpoints](#input\_custom\_private\_endpoints) | Map of custom private endpoints to create | <pre>map(object({<br/>    resource_id       = string<br/>    subresource_names = list(string)<br/>    manual            = bool<br/>  }))</pre> | `{}` | no |
| <a name="input_dns_resolver_inbound_subnet_prefix"></a> [dns\_resolver\_inbound\_subnet\_prefix](#input\_dns\_resolver\_inbound\_subnet\_prefix) | Address prefix for the DNS resolver inbound endpoint subnet | `list(string)` | <pre>[<br/>  "10.0.22.0/28"<br/>]</pre> | no |
| <a name="input_dns_resolver_outbound_subnet_prefix"></a> [dns\_resolver\_outbound\_subnet\_prefix](#input\_dns\_resolver\_outbound\_subnet\_prefix) | Address prefix for the DNS resolver outbound endpoint subnet | `list(string)` | <pre>[<br/>  "10.0.22.16/28"<br/>]</pre> | no |
| <a name="input_enable_aci_subnet"></a> [enable\_aci\_subnet](#input\_enable\_aci\_subnet) | Create a delegated subnet for Azure Container Instances | `bool` | `false` | no |
| <a name="input_enable_application_gateway"></a> [enable\_application\_gateway](#input\_enable\_application\_gateway) | Deploy Azure Application Gateway v2 with zone redundancy | `bool` | `false` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Deploy Azure Bastion for secure jump-host access without public SSH | `bool` | `false` | no |
| <a name="input_enable_ddos_protection"></a> [enable\_ddos\_protection](#input\_enable\_ddos\_protection) | Enable Azure DDoS Network Protection plan on the VNet | `bool` | `false` | no |
| <a name="input_enable_dns_resolver"></a> [enable\_dns\_resolver](#input\_enable\_dns\_resolver) | Deploy Azure DNS Private Resolver with inbound and outbound endpoints | `bool` | `false` | no |
| <a name="input_enable_er_gateway"></a> [enable\_er\_gateway](#input\_enable\_er\_gateway) | Deploy an ExpressRoute virtual network gateway | `bool` | `false` | no |
| <a name="input_enable_expressroute"></a> [enable\_expressroute](#input\_enable\_expressroute) | Deploy an ExpressRoute circuit for dedicated private connectivity | `bool` | `false` | no |
| <a name="input_enable_firewall"></a> [enable\_firewall](#input\_enable\_firewall) | Deploy Azure Firewall into AzureFirewallSubnet for centralized egress control | `bool` | `false` | no |
| <a name="input_enable_hub_spoke"></a> [enable\_hub\_spoke](#input\_enable\_hub\_spoke) | Enable hub-spoke network topology with VNet peering | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Attach a NAT Gateway to the AKS subnet for static egress IP | `bool` | `false` | no |
| <a name="input_enable_network_watcher"></a> [enable\_network\_watcher](#input\_enable\_network\_watcher) | Create an Azure Network Watcher instance for the region | `bool` | `false` | no |
| <a name="input_enable_nsg_flow_logs"></a> [enable\_nsg\_flow\_logs](#input\_enable\_nsg\_flow\_logs) | Enable NSG flow logs with Network Watcher and traffic analytics | `bool` | `false` | no |
| <a name="input_enable_postgres_subnet_delegation"></a> [enable\_postgres\_subnet\_delegation](#input\_enable\_postgres\_subnet\_delegation) | Create a delegated subnet for PostgreSQL flexible server VNet injection | `bool` | `false` | no |
| <a name="input_enable_private_dns"></a> [enable\_private\_dns](#input\_enable\_private\_dns) | Create private DNS zones for AKS and Key Vault and link them to the VNet | `bool` | `false` | no |
| <a name="input_enable_private_link_service"></a> [enable\_private\_link\_service](#input\_enable\_private\_link\_service) | Expose an internal load balancer as a Private Link service | `bool` | `false` | no |
| <a name="input_enable_route_table"></a> [enable\_route\_table](#input\_enable\_route\_table) | Create a custom route table for private subnet routing | `bool` | `false` | no |
| <a name="input_enable_traffic_manager"></a> [enable\_traffic\_manager](#input\_enable\_traffic\_manager) | Deploy an Azure Traffic Manager profile for global load balancing | `bool` | `false` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Deploy a VPN gateway into the GatewaySubnet | `bool` | `false` | no |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Enable Web Application Firewall policy on the Application Gateway | `bool` | `false` | no |
| <a name="input_er_authorization_key"></a> [er\_authorization\_key](#input\_er\_authorization\_key) | Authorization key for the ExpressRoute circuit connection | `string` | `""` | no |
| <a name="input_er_bandwidth_mbps"></a> [er\_bandwidth\_mbps](#input\_er\_bandwidth\_mbps) | ExpressRoute circuit bandwidth in Mbps | `number` | `1000` | no |
| <a name="input_er_gateway_sku"></a> [er\_gateway\_sku](#input\_er\_gateway\_sku) | SKU for the ExpressRoute gateway (ErGw1AZ, ErGw2AZ, ErGw3AZ) | `string` | `"ErGw1AZ"` | no |
| <a name="input_er_peering_location"></a> [er\_peering\_location](#input\_er\_peering\_location) | ExpressRoute peering location (e.g. Silicon Valley) | `string` | `"Silicon Valley"` | no |
| <a name="input_er_service_provider"></a> [er\_service\_provider](#input\_er\_service\_provider) | ExpressRoute service provider name (e.g. Equinix) | `string` | `"Equinix"` | no |
| <a name="input_er_sku_family"></a> [er\_sku\_family](#input\_er\_sku\_family) | ExpressRoute circuit SKU family: MeteredData or UnlimitedData | `string` | `"MeteredData"` | no |
| <a name="input_er_sku_tier"></a> [er\_sku\_tier](#input\_er\_sku\_tier) | ExpressRoute circuit SKU tier: Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_firewall_private_ip"></a> [firewall\_private\_ip](#input\_firewall\_private\_ip) | Private IP of Azure Firewall for UDR routing | `string` | `""` | no |
| <a name="input_firewall_sku_tier"></a> [firewall\_sku\_tier](#input\_firewall\_sku\_tier) | Azure Firewall SKU tier: Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_firewall_subnet_address_prefix"></a> [firewall\_subnet\_address\_prefix](#input\_firewall\_subnet\_address\_prefix) | Address prefix for AzureFirewallSubnet (must be /26 or larger) | `list(string)` | <pre>[<br/>  "10.0.240.0/26"<br/>]</pre> | no |
| <a name="input_flow_log_retention_days"></a> [flow\_log\_retention\_days](#input\_flow\_log\_retention\_days) | Number of days to retain NSG flow logs in the storage account | `number` | `30` | no |
| <a name="input_flow_log_storage_account_id"></a> [flow\_log\_storage\_account\_id](#input\_flow\_log\_storage\_account\_id) | Storage account resource ID for NSG flow log retention | `string` | `""` | no |
| <a name="input_foundation_resource_group_name"></a> [foundation\_resource\_group\_name](#input\_foundation\_resource\_group\_name) | Name of the foundation resource group where networking resources will be deployed | `string` | n/a | yes |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | Address prefix for the GatewaySubnet (must be /27 or larger) | `list(string)` | <pre>[<br/>  "10.100.255.0/27"<br/>]</pre> | no |
| <a name="input_hub_vnet_address_space"></a> [hub\_vnet\_address\_space](#input\_hub\_vnet\_address\_space) | Address space for the hub VNet | `list(string)` | <pre>[<br/>  "10.100.0.0/16"<br/>]</pre> | no |
| <a name="input_internal_lb_frontend_ip_id"></a> [internal\_lb\_frontend\_ip\_id](#input\_internal\_lb\_frontend\_ip\_id) | Resource ID of the internal load balancer frontend IP for Private Link | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for networking resources | `string` | `"eastus"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for NSG diagnostic settings | `string` | `""` | no |
| <a name="input_log_analytics_workspace_resource_id"></a> [log\_analytics\_workspace\_resource\_id](#input\_log\_analytics\_workspace\_resource\_id) | Full resource ID of the Log Analytics workspace for traffic analytics | `string` | `""` | no |
| <a name="input_pls_auto_approval_subscription_ids"></a> [pls\_auto\_approval\_subscription\_ids](#input\_pls\_auto\_approval\_subscription\_ids) | Subscription IDs that can auto-approve Private Link connections | `list(string)` | `[]` | no |
| <a name="input_pls_visibility_subscription_ids"></a> [pls\_visibility\_subscription\_ids](#input\_pls\_visibility\_subscription\_ids) | Subscription IDs that can see the Private Link service | `list(string)` | `[]` | no |
| <a name="input_postgres_subnet_address_prefix"></a> [postgres\_subnet\_address\_prefix](#input\_postgres\_subnet\_address\_prefix) | Address prefix for the PostgreSQL delegated subnet | `list(string)` | <pre>[<br/>  "10.0.20.0/24"<br/>]</pre> | no |
| <a name="input_private_subnet_address_prefixes"></a> [private\_subnet\_address\_prefixes](#input\_private\_subnet\_address\_prefixes) | Address prefixes for the private subnet | `list(string)` | <pre>[<br/>  "10.0.2.0/24"<br/>]</pre> | no |
| <a name="input_public_subnet_address_prefixes"></a> [public\_subnet\_address\_prefixes](#input\_public\_subnet\_address\_prefixes) | Address prefixes for the public subnet | `list(string)` | <pre>[<br/>  "10.0.1.0/24"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_tm_dns_relative_name"></a> [tm\_dns\_relative\_name](#input\_tm\_dns\_relative\_name) | Relative DNS name for the Traffic Manager profile (globally unique) | `string` | `""` | no |
| <a name="input_tm_health_probe_path"></a> [tm\_health\_probe\_path](#input\_tm\_health\_probe\_path) | HTTP path used by Traffic Manager health probes | `string` | `"/health"` | no |
| <a name="input_tm_primary_endpoint_resource_id"></a> [tm\_primary\_endpoint\_resource\_id](#input\_tm\_primary\_endpoint\_resource\_id) | Azure resource ID of the primary Traffic Manager endpoint | `string` | `""` | no |
| <a name="input_tm_primary_weight"></a> [tm\_primary\_weight](#input\_tm\_primary\_weight) | Weight for the primary endpoint when using Weighted routing (1–1000) | `number` | `80` | no |
| <a name="input_tm_routing_method"></a> [tm\_routing\_method](#input\_tm\_routing\_method) | Traffic Manager routing method: Priority, Weighted, Performance, or Geographic | `string` | `"Priority"` | no |
| <a name="input_tm_secondary_endpoint_resource_id"></a> [tm\_secondary\_endpoint\_resource\_id](#input\_tm\_secondary\_endpoint\_resource\_id) | Azure resource ID of the secondary Traffic Manager endpoint | `string` | `""` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address space for the virtual network | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network | `string` | n/a | yes |
| <a name="input_vpn_gateway_sku"></a> [vpn\_gateway\_sku](#input\_vpn\_gateway\_sku) | SKU for the VPN gateway (VpnGw1, VpnGw2, VpnGw3, Basic) | `string` | `"VpnGw1"` | no |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | WAF policy mode: Detection (log only) or Prevention (block) | `string` | `"Detection"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_subnet_id"></a> [aks\_subnet\_id](#output\_aks\_subnet\_id) | ID of the AKS subnet |
| <a name="output_hub_vnet_id"></a> [hub\_vnet\_id](#output\_hub\_vnet\_id) | Resource ID of the hub VNet (null if hub-spoke is disabled) |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | ID of the NAT gateway |
| <a name="output_private_nsg_id"></a> [private\_nsg\_id](#output\_private\_nsg\_id) | ID of the private network security group |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | ID of the private subnet |
| <a name="output_public_nsg_id"></a> [public\_nsg\_id](#output\_public\_nsg\_id) | ID of the public network security group |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | ID of the public subnet |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the virtual network |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | Resource ID of the VPN gateway (null if disabled) |
<!-- END_TF_DOCS -->
