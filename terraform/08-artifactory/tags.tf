locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "artifactory"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
