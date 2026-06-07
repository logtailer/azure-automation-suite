
data "terraform_remote_state" "foundation" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "tfstate"
    key                  = "01-foundation/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# Fetch network resources from remote state (02-networking/application-network)
data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "tfstate"
    key                  = "02-networking/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# Use these outputs in your AKS and node pool resources:
# data.terraform_remote_state.networking.outputs.vnet_id
# data.terraform_remote_state.networking.outputs.vnet_name
# data.terraform_remote_state.networking.outputs.public_subnet1_id
# data.terraform_remote_state.networking.outputs.public_subnet2_id
# data.terraform_remote_state.networking.outputs.private_subnet1_id
# data.terraform_remote_state.networking.outputs.private_subnet2_id
# data.terraform_remote_state.networking.outputs.public_nsg_id
# data.terraform_remote_state.networking.outputs.private_nsg_id
