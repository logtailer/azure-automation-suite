variable "argocd_domain" {
  description = "Domain name for ArgoCD server"
  type        = string
  default     = "argocd.local"
}

variable "git_repository_url" {
  description = "Git repository URL for GitOps"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "production"
}
