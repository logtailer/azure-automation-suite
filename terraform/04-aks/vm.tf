# Compute Module - Virtual Machines
# This module creates virtual machines and associated security configurations

# Network Security Group for VM
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.environment}-vm-nsg"
  location            = data.terraform_remote_state.foundation.outputs.location
  resource_group_name = data.terraform_remote_state.foundation.outputs.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Component   = "compute"
  }
}

# Associate NSG with VM NIC
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg_assoc" {
  network_interface_id      = data.terraform_remote_state.networking.outputs.vm_network_interface_id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# TLS private key for SSH
resource "tls_private_key" "vm_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key locally
resource "local_file" "private_key" {
  filename        = "${path.module}/privatekey.pem"
  content         = tls_private_key.vm_key_pair.private_key_openssh
  file_permission = "0600"
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.environment}-${var.vm_name}"
  location                        = data.terraform_remote_state.foundation.outputs.location
  resource_group_name             = data.terraform_remote_state.foundation.outputs.resource_group_name
  size                            = var.vm_size
  disable_password_authentication = true
  admin_username                  = var.admin_username
  network_interface_ids           = [data.terraform_remote_state.networking.outputs.vm_network_interface_id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm_key_pair.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Component   = "compute"
  }
}
