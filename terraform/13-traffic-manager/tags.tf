locals {
  common_tags = merge(
    {
      Project    = "azure-platform"
      ManagedBy  = "terraform"
      Component  = "traffic-manager"
      Repository = "azure-automation-suite"
    },
    var.tags
  )
}
