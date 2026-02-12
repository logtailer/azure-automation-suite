locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "backup"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
