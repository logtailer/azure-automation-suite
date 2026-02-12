locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "aks"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
