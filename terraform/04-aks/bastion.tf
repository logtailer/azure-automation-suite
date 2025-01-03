
# Azure Bastion Host

locals {
  bastion_subnet_id = data.terraform_remote_state.networking.outputs.public_subnet1_id
}

resource "azurerm_bastion_host" "aks_bastion" {
  name                = "aks-bastion"
  location            = azurerm_kubernetes_cluster.cluster.location
  resource_group_name = azurerm_kubernetes_cluster.cluster.resource_group_name
  sku                 = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = local.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "aks-bastion-pip"
  location            = azurerm_kubernetes_cluster.cluster.location
  resource_group_name = azurerm_kubernetes_cluster.cluster.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}