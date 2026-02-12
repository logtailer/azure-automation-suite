locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "cost-management"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
