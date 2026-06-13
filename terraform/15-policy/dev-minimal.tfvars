# Audit mode only — no hard denies in dev (makes teardown easier)
enforce_policies = false

assign_at_management_group = false
management_group_id        = ""
non_compliance_message     = "Resource does not comply with azure-platform policy baseline"

# Dev SKU exemption — allow B-series VMs in dev
create_dev_sku_exemption = false
dev_vm_resource_id       = ""
dev_exemption_expiry     = "2027-12-31T00:00:00Z"
dev_exemption_ticket_ref = "DEV-LEARNING"

create_legacy_rg_exemption = false
legacy_resource_group_id   = ""
legacy_exemption_expiry    = "2027-12-31T00:00:00Z"

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
