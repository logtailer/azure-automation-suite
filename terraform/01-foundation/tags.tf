locals {
  common_tags = merge(
    {
      Project            = "azure-platform"
      ManagedBy          = "terraform"
      Repository         = "azure-automation-suite"
      DataClassification = var.data_classification
    },
    var.tags
  )
}
