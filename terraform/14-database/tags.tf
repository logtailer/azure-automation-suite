locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "database"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
