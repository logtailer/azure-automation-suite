locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "policy"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
