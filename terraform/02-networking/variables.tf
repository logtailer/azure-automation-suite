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
