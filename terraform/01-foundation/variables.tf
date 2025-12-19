variable "resource_group_name" {
  description = "Name of the resource group for storage account"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account"
  type        = string
}

variable "storage_account_resource_group" {
  description = "Resource group where the storage account exists"
  type        = string
}

variable "container_name" {
  description = "Name of the container for the component"
  type        = string
}
