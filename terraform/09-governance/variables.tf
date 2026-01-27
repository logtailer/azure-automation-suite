variable "subscription_id" {
  description = "Azure subscription ID for policy assignments"
  type        = string
}

variable "allowed_locations" {
  description = "List of allowed Azure regions for deployments"
  type        = list(string)
  default     = ["eastus", "eastus2", "westus2", "westeurope"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
