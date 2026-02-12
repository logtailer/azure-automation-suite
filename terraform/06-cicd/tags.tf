locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "cicd"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
