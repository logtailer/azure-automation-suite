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

variable "aks_cicd_subnet_address_prefixes" {
  description = "Address prefixes for the AKS CI/CD subnet"
  type        = list(string)
  default     = ["10.0.5.0/24"]
}

variable "firewall_subnet_address_prefixes" {
  description = "Address prefixes for Azure Firewall subnet"
  type        = list(string)
  default     = ["10.0.6.0/26"]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
