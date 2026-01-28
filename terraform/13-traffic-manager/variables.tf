variable "foundation_resource_group_name" {
  description = "Name of the foundation resource group"
  type        = string
}

variable "traffic_manager_name" {
  description = "Name of the Traffic Manager profile"
  type        = string
  default     = "platform-tm"
}

variable "routing_method" {
  description = "Traffic routing method: Priority, Weighted, Performance, or Geographic"
  type        = string
  default     = "Priority"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
