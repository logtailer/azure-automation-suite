locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "idp"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
