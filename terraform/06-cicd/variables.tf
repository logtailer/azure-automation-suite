variable "resource_group_name" {
  description = "Name of the resource group for this component"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "container_registry_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "artifacts_storage_name" {
  description = "Name of the storage account for build artifacts"
  type        = string
}

variable "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  type        = string
}

variable "vmss_sku" {
  description = "SKU for the VMSS instances"
  type        = string
  default     = "Standard_B2s"
}

variable "vmss_instances" {
  description = "Number of instances in the scale set"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username for the build agents"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for the build agents"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the build agents"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
