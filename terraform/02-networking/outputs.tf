output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = azurerm_subnet.private.id
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "aks_cicd_subnet_id" {
  description = "Subnet ID for CI/CD AKS cluster"
  value       = azurerm_subnet.aks_cicd.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = azurerm_nat_gateway.main.id
}

output "public_nsg_id" {
  description = "ID of the public network security group"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "ID of the private network security group"
  value       = azurerm_network_security_group.private.id
}
