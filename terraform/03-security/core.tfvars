# Security module configuration
resource_group_name = "rg-security"
location = "East US"

key_vault_name = "kv-platform-secrets-001"
key_vault_sku = "standard"
soft_delete_retention_days = 7
purge_protection_enabled = false

ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... # Add your SSH public key here"

tags = {
  Environment = "Production"
  Project     = "Platform"
  Component   = "Security"
}
