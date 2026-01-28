# Core configuration
variable "resource_group_name" {
  description = "Existing resource group for AKS deployment"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "component_name" {
  description = "Component name"
  type        = string
  default     = "cicd"
}

# Backend configuration
variable "tfstate_resource_group_name" {
  description = "Resource group containing Terraform state"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Storage account for Terraform state"
  type        = string
}

# GitHub configuration
variable "github_token" {
  description = "GitHub PAT with repo, workflow, admin:repo_hook permissions"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "Secret for GitHub webhook authentication"
  type        = string
  sensitive   = true
}

variable "github_repository_owner" {
  description = "GitHub repository owner (username for personal repos)"
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
}

# AKS configuration
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for AKS cluster"
  type        = string
  default     = "aks-cicd"
}

variable "system_node_count" {
  description = "Number of nodes in system pool"
  type        = number
  default     = 1
}

variable "system_node_size" {
  description = "VM size for system nodes"
  type        = string
  default     = "Standard_B2s"  # 2 vCPU, 4 GB RAM
}

variable "runner_node_min_count" {
  description = "Minimum nodes in runner pool (scale-to-zero)"
  type        = number
  default     = 0
}

variable "runner_node_max_count" {
  description = "Maximum nodes in runner pool"
  type        = number
  default     = 5
}

variable "runner_node_size" {
  description = "VM size for runner nodes"
  type        = string
  default     = "Standard_D2s_v3"  # 2 vCPU, 8 GB RAM
}

# Actions Runner Controller configuration
variable "arc_namespace" {
  description = "Kubernetes namespace for ARC"
  type        = string
  default     = "actions-runner-system"
}

variable "runner_scale_set_name" {
  description = "Name for the runner scale set"
  type        = string
  default     = "arc-runner-set"
}

variable "runner_min_replicas" {
  description = "Minimum runner replicas"
  type        = number
  default     = 0
}

variable "runner_max_replicas" {
  description = "Maximum runner replicas"
  type        = number
  default     = 5
}

# ArgoCD configuration
variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.0.0"
}

# Cost monitoring
variable "enable_component_budget" {
  description = "Enable budget monitoring"
  type        = bool
  default     = true
}

variable "component_budget_amount" {
  description = "Monthly budget in USD"
  type        = number
  default     = 100
}

variable "cost_alert_threshold" {
  description = "Budget alert threshold percentage"
  type        = number
  default     = 80
}

variable "cost_alert_emails" {
  description = "Email addresses for cost alerts"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
