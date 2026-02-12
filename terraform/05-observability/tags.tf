locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "observability"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
