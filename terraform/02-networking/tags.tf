locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "networking"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
