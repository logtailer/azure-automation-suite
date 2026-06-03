variable "resource_group_name" {
  description = "Name of the resource group for component resources"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "tfstate_resource_group_name" {
  description = "Name of the resource group for terraform state storage"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Name of the Azure Storage Account for terraform state"
  type        = string
}

variable "component_name" {
  description = "Name of the component (used for container name)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "data_classification" {
  description = "Data classification level for compliance tagging (public, internal, confidential)"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["public", "internal", "confidential"], var.data_classification)
    error_message = "data_classification must be one of: public, internal, confidential."
  }
}

# Cost monitoring variables
variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD for cost monitoring"
  type        = number
  default     = 100
}

variable "cost_alert_threshold_1" {
  description = "First cost alert threshold percentage (e.g., 50 for 50%)"
  type        = number
  default     = 50
}

variable "cost_alert_threshold_2" {
  description = "Second cost alert threshold percentage (e.g., 80 for 80%)"
  type        = number
  default     = 80
}

variable "cost_alert_threshold_3" {
  description = "Third cost alert threshold percentage (e.g., 100 for 100%)"
  type        = number
  default     = 100
}

variable "cost_alert_emails" {
  description = "List of email addresses to receive cost alerts"
  type        = list(string)
  default     = []
}

variable "enable_component_budget" {
  description = "Whether to create a separate budget for this specific component"
  type        = bool
  default     = false
}

variable "component_budget_amount" {
  description = "Budget amount for individual component (if enabled)"
  type        = number
  default     = 20
}

# Component-wise budget configuration
variable "component_budgets" {
  description = "Budget configuration for each component type"
  type = map(object({
    amount    = number
    threshold = number
  }))
  default = {
    foundation    = { amount = 5, threshold = 80 }
    networking    = { amount = 10, threshold = 80 }
    security      = { amount = 3, threshold = 80 }
    aks           = { amount = 25, threshold = 80 }
    observability = { amount = 5, threshold = 80 }
    cicd          = { amount = 2, threshold = 80 }
    idp           = { amount = 5, threshold = 80 }
  }
}

variable "enable_service_bus" {
  description = "Deploy an Azure Service Bus namespace with platform event queues"
  type        = bool
  default     = false
}

variable "service_bus_namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
  default     = ""
}

variable "service_bus_sku" {
  description = "Service Bus SKU: Basic, Standard, or Premium"
  type        = string
  default     = "Standard"
}

variable "service_bus_capacity" {
  description = "Messaging units for Premium SKU (1, 2, 4, 8, or 16)"
  type        = number
  default     = 1
}

variable "enable_front_door" {
  description = "Deploy Azure Front Door (CDN Frontdoor) profile and endpoint"
  type        = bool
  default     = false
}

variable "front_door_sku" {
  description = "Front Door SKU: Standard_AzureFrontDoor or Premium_AzureFrontDoor"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "enable_event_grid" {
  description = "Deploy an Event Grid topic with CloudEvents schema for platform event routing"
  type        = bool
  default     = false
}

variable "enable_acr" {
  description = "Deploy an Azure Container Registry for private image storage"
  type        = bool
  default     = false
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique)"
  type        = string
  default     = ""
}

variable "acr_sku" {
  description = "ACR SKU: Basic, Standard, or Premium"
  type        = string
  default     = "Standard"
}

variable "acr_private_only" {
  description = "Disable public network access on the ACR (Premium only)"
  type        = bool
  default     = false
}

variable "acr_geo_replications" {
  description = "List of Azure regions to geo-replicate the ACR to (Premium only)"
  type        = list(string)
  default     = []
}

variable "acr_retention_days" {
  description = "Number of days to retain untagged manifests"
  type        = number
  default     = 30
}

variable "acr_content_trust" {
  description = "Enable content trust (image signing) on the ACR"
  type        = bool
  default     = false
}

variable "enable_platform_storage" {
  description = "Deploy a platform storage account for artifacts and backups"
  type        = bool
  default     = false
}

variable "platform_storage_account_name" {
  description = "Name of the platform storage account (must be globally unique)"
  type        = string
  default     = ""
}

variable "platform_storage_replication" {
  description = "Storage replication type: LRS, ZRS, GRS, GZRS"
  type        = string
  default     = "ZRS"
}

variable "enable_logic_app" {
  description = "Deploy a Logic App workflow to process and route Azure Monitor alerts"
  type        = bool
  default     = false
}

variable "teams_webhook_url" {
  description = "Microsoft Teams incoming webhook URL for alert notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_apim" {
  description = "Deploy an Azure API Management instance"
  type        = bool
  default     = false
}

variable "apim_name" {
  description = "Name of the API Management service (must be globally unique)"
  type        = string
  default     = ""
}

variable "apim_publisher_name" {
  description = "Publisher name shown in the APIM developer portal"
  type        = string
  default     = "Platform Team"
}

variable "apim_publisher_email" {
  description = "Publisher email for APIM notifications"
  type        = string
  default     = ""
}

variable "apim_sku" {
  description = "API Management SKU: Developer, Basic, Standard, or Premium"
  type        = string
  default     = "Developer"
}

variable "apim_capacity" {
  description = "Number of APIM scale units"
  type        = number
  default     = 1
}

variable "apim_vnet_type" {
  description = "APIM VNet integration type: None, External, or Internal"
  type        = string
  default     = "None"
}

variable "apim_subnet_id" {
  description = "Subnet resource ID for APIM VNet injection (External or Internal mode)"
  type        = string
  default     = ""
}

variable "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key for APIM logging"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_notification_hub" {
  description = "Deploy an Azure Notification Hub namespace for push notifications"
  type        = bool
  default     = false
}

variable "notification_hub_sku" {
  description = "Notification Hub namespace SKU: Free, Basic, or Standard"
  type        = string
  default     = "Free"
}

variable "apns_bundle_id" {
  description = "Apple APNs bundle ID for iOS push notifications"
  type        = string
  default     = ""
}

variable "apns_production" {
  description = "Use APNs production (true) or sandbox (false) endpoint"
  type        = bool
  default     = false
}

variable "apns_key_id" {
  description = "APNs authentication key ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "apns_team_id" {
  description = "Apple Developer Team ID"
  type        = string
  default     = ""
}

variable "apns_token" {
  description = "APNs authentication token content"
  type        = string
  default     = ""
  sensitive   = true
}

variable "gcm_api_key" {
  description = "Google Firebase Cloud Messaging API key for Android push notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_app_config" {
  description = "Deploy an Azure App Configuration store for centralised feature flags and settings"
  type        = bool
  default     = false
}

variable "app_config_name" {
  description = "Name of the App Configuration store (must be globally unique)"
  type        = string
  default     = ""
}

variable "app_config_sku" {
  description = "App Configuration SKU: free or standard"
  type        = string
  default     = "standard"
}

variable "app_config_public_access" {
  description = "Allow public network access to the App Configuration store"
  type        = bool
  default     = false
}

variable "app_config_reader_principal_ids" {
  description = "Map of principal names to object IDs granted App Configuration Data Reader"
  type        = map(string)
  default     = {}
}

variable "app_config_private_endpoint_subnet_id" {
  description = "Subnet ID for the App Configuration private endpoint"
  type        = string
  default     = ""
}
