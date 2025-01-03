
# Fetch network resources from remote state (02-networking/application-network)
data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    resource_group_name  = "<networking-tfstate-rg>"      # TODO: update to actual RG
    storage_account_name = "<networking-tfstate-storage>" # TODO: update to actual storage
    container_name       = "tfstate"
    key                  = "02-networking/application-network/terraform.tfstate"
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
