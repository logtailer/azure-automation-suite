locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "appgateway"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
