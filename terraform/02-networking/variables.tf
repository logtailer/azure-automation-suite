variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group where networking resources will be deployed"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_address_prefixes" {
  description = "Address prefixes for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
  default     = ["10.0.10.0/23"]
}

variable "enable_hub_spoke" {
  description = "Enable hub-spoke network topology with VNet peering"
  type        = bool
  default     = false
}

variable "hub_vnet_address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
  default     = ["10.100.0.0/16"]
}

variable "enable_vpn_gateway" {
  description = "Deploy a VPN gateway into the GatewaySubnet"
  type        = bool
  default     = false
}

variable "gateway_subnet_address_prefix" {
  description = "Address prefix for the GatewaySubnet (must be /27 or larger)"
  type        = list(string)
  default     = ["10.100.255.0/27"]
}

variable "vpn_gateway_sku" {
  description = "SKU for the VPN gateway (VpnGw1, VpnGw2, VpnGw3, Basic)"
  type        = string
  default     = "VpnGw1"
}

variable "enable_ddos_protection" {
  description = "Enable Azure DDoS Network Protection plan on the VNet"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_route_table" {
  description = "Create a custom route table for private subnet routing"
  type        = bool
  default     = false
}

variable "firewall_private_ip" {
  description = "Private IP of Azure Firewall for UDR routing"
  type        = string
  default     = ""
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion for secure jump-host access without public SSH"
  type        = bool
  default     = false
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for AzureBastionSubnet (must be /26 or larger)"
  type        = list(string)
  default     = ["10.0.250.0/26"]
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for NSG diagnostic settings"
  type        = string
  default     = ""
}

variable "enable_nsg_flow_logs" {
  description = "Enable NSG flow logs with Network Watcher and traffic analytics"
  type        = bool
  default     = false
}

variable "flow_log_storage_account_id" {
  description = "Storage account resource ID for NSG flow log retention"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_resource_id" {
  description = "Full resource ID of the Log Analytics workspace for traffic analytics"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for networking resources"
  type        = string
  default     = "eastus"
}

variable "enable_private_dns" {
  description = "Create private DNS zones for AKS and Key Vault and link them to the VNet"
  type        = bool
  default     = false
}

variable "aks_private_dns_zone_name" {
  description = "Private DNS zone name for AKS (e.g. privatelink.eastus.azmk8s.io)"
  type        = string
  default     = "privatelink.eastus.azmk8s.io"
}

variable "enable_firewall" {
  description = "Deploy Azure Firewall into AzureFirewallSubnet for centralized egress control"
  type        = bool
  default     = false
}

variable "firewall_subnet_address_prefix" {
  description = "Address prefix for AzureFirewallSubnet (must be /26 or larger)"
  type        = list(string)
  default     = ["10.0.240.0/26"]
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier: Standard or Premium"
  type        = string
  default     = "Standard"
}

variable "enable_application_gateway" {
  description = "Deploy Azure Application Gateway v2 with zone redundancy"
  type        = bool
  default     = false
}

variable "appgw_subnet_address_prefix" {
  description = "Address prefix for the Application Gateway subnet (minimum /24)"
  type        = list(string)
  default     = ["10.0.230.0/24"]
}

variable "appgw_sku_name" {
  description = "Application Gateway SKU name"
  type        = string
  default     = "Standard_v2"
}

variable "appgw_sku_tier" {
  description = "Application Gateway SKU tier"
  type        = string
  default     = "Standard_v2"
}

variable "appgw_capacity" {
  description = "Application Gateway instance count (1–125)"
  type        = number
  default     = 2
}

variable "enable_waf" {
  description = "Enable Web Application Firewall policy on the Application Gateway"
  type        = bool
  default     = false
}

variable "waf_mode" {
  description = "WAF policy mode: Detection (log only) or Prevention (block)"
  type        = string
  default     = "Detection"
}

variable "enable_nat_gateway" {
  description = "Attach a NAT Gateway to the AKS subnet for static egress IP"
  type        = bool
  default     = false
}

variable "enable_postgres_subnet_delegation" {
  description = "Create a delegated subnet for PostgreSQL flexible server VNet injection"
  type        = bool
  default     = false
}

variable "postgres_subnet_address_prefix" {
  description = "Address prefix for the PostgreSQL delegated subnet"
  type        = list(string)
  default     = ["10.0.20.0/24"]
}

variable "enable_aci_subnet" {
  description = "Create a delegated subnet for Azure Container Instances"
  type        = bool
  default     = false
}

variable "aci_subnet_address_prefix" {
  description = "Address prefix for the ACI delegated subnet"
  type        = list(string)
  default     = ["10.0.21.0/24"]
}

variable "enable_expressroute" {
  description = "Deploy an ExpressRoute circuit for dedicated private connectivity"
  type        = bool
  default     = false
}

variable "er_service_provider" {
  description = "ExpressRoute service provider name (e.g. Equinix)"
  type        = string
  default     = "Equinix"
}

variable "er_peering_location" {
  description = "ExpressRoute peering location (e.g. Silicon Valley)"
  type        = string
  default     = "Silicon Valley"
}

variable "er_bandwidth_mbps" {
  description = "ExpressRoute circuit bandwidth in Mbps"
  type        = number
  default     = 1000
}

variable "er_sku_tier" {
  description = "ExpressRoute circuit SKU tier: Standard or Premium"
  type        = string
  default     = "Standard"
}

variable "er_sku_family" {
  description = "ExpressRoute circuit SKU family: MeteredData or UnlimitedData"
  type        = string
  default     = "MeteredData"
}

variable "enable_er_gateway" {
  description = "Deploy an ExpressRoute virtual network gateway"
  type        = bool
  default     = false
}

variable "er_gateway_sku" {
  description = "SKU for the ExpressRoute gateway (ErGw1AZ, ErGw2AZ, ErGw3AZ)"
  type        = string
  default     = "ErGw1AZ"
}

variable "er_authorization_key" {
  description = "Authorization key for the ExpressRoute circuit connection"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_private_link_service" {
  description = "Expose an internal load balancer as a Private Link service"
  type        = bool
  default     = false
}

variable "internal_lb_frontend_ip_id" {
  description = "Resource ID of the internal load balancer frontend IP for Private Link"
  type        = string
  default     = ""
}

variable "pls_auto_approval_subscription_ids" {
  description = "Subscription IDs that can auto-approve Private Link connections"
  type        = list(string)
  default     = []
}

variable "pls_visibility_subscription_ids" {
  description = "Subscription IDs that can see the Private Link service"
  type        = list(string)
  default     = []
}

variable "custom_private_endpoints" {
  description = "Map of custom private endpoints to create"
  type = map(object({
    resource_id       = string
    subresource_names = list(string)
    manual            = bool
  }))
  default = {}
}

variable "additional_vnet_peerings" {
  description = "Map of additional VNet peerings (name -> remote VNet resource ID)"
  type        = map(string)
  default     = {}
}

variable "enable_er_gateway" {
  description = "Whether an ExpressRoute gateway is deployed (used to set use_remote_gateways)"
  type        = bool
  default     = false
}

variable "enable_network_watcher" {
  description = "Create an Azure Network Watcher instance for the region"
  type        = bool
  default     = false
}

variable "flow_log_retention_days" {
  description = "Number of days to retain NSG flow logs in the storage account"
  type        = number
  default     = 30
}
