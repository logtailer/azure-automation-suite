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

variable "probe_path" {
  description = "Health probe path for Traffic Manager endpoints"
  type        = string
  default     = "/health"
}

variable "probe_interval_in_seconds" {
  description = "Health probe interval in seconds"
  type        = number
  default     = 30
}
