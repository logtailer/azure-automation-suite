variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the public subnet for Application Gateway"
  type        = string
  default     = "public-subnet"
}

variable "appgw_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "platform-appgw"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
