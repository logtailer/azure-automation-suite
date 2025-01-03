variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "azure-platform"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "Central India"
}

variable "tfstate_resource_group_name" {
  description = "The resource group name where Terraform state is stored"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "The storage account name where Terraform state is stored"
  type        = string
}
