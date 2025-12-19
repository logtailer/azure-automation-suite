# Networking component variables
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment" { type = string }

variable "vnet_name" { type = string }
variable "vnet_address_space" { type = string }

# Two public subnets
variable "public_subnet1_name" { type = string }
variable "public_subnet1_cidr" { type = string }
variable "public_subnet2_name" { type = string }
variable "public_subnet2_cidr" { type = string }

# Two private subnets
variable "private_subnet1_name" { type = string }
variable "private_subnet1_cidr" { type = string }
variable "private_subnet2_name" { type = string }
variable "private_subnet2_cidr" { type = string }
# Networking Module Variables


