locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "governance"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
