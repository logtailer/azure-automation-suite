locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "security"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
