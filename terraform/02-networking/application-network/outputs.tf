# Networking Module Outputs

# Virtual Network Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.core_vpc.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.core_vpc.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.core_vpc.address_space
}

# Subnet Outputs
output "public_subnet1_id" {
  description = "ID of the public subnet 1"
  value       = azurerm_subnet.public1.id
}

output "public_subnet1_name" {
  description = "Name of the public subnet 1"
  value       = azurerm_subnet.public1.name
}

output "public_subnet2_id" {
  description = "ID of the public subnet 2"
  value       = azurerm_subnet.public2.id
}

output "public_subnet2_name" {
  description = "Name of the public subnet 2"
  value       = azurerm_subnet.public2.name
}

output "private_subnet1_id" {
  description = "ID of the private subnet 1"
  value       = azurerm_subnet.private1.id
}

output "private_subnet1_name" {
  description = "Name of the private subnet 1"
  value       = azurerm_subnet.private1.name
}

output "private_subnet2_id" {
  description = "ID of the private subnet 2"
  value       = azurerm_subnet.private2.id
}

output "private_subnet2_name" {
  description = "Name of the private subnet 2"
  value       = azurerm_subnet.private2.name
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = azurerm_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT gateway"
  value       = azurerm_public_ip.nat_gateway.ip_address
}

# Network Security Group Outputs
output "public_nsg_id" {
  description = "ID of the public network security group"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "ID of the private network security group"
  value       = azurerm_network_security_group.private.id
}

# VM Networking Outputs
output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.vm_ip.ip_address
}

output "vm_network_interface_id" {
  description = "ID of the VM network interface"
  value       = azurerm_network_interface.vm_interface.id
}

# Private Endpoint Outputs
output "private_endpoint_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "storage_private_dns_zone_id" {
  description = "ID of the storage private DNS zone"
  value       = azurerm_private_dns_zone.storage.id
}

output "keyvault_private_dns_zone_id" {
  description = "ID of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.id
}

output "acr_private_dns_zone_id" {
  description = "ID of the ACR private DNS zone"  
  value       = azurerm_private_dns_zone.acr.id
}
