locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
