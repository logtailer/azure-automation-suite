location                        = "Central India"
foundation_resource_group_name  = "azure-platform-dev-rg"
vnet_name                       = "vnet-dev"
vnet_address_space              = ["10.0.0.0/16"]
public_subnet_address_prefixes  = ["10.0.1.0/24"]
private_subnet_address_prefixes = ["10.0.2.0/24"]
aks_subnet_address_prefixes     = ["10.0.3.0/24"]

# Disable everything that charges per-hour
enable_firewall             = false
enable_vpn_gateway          = false
enable_ddos_protection      = false
enable_nat_gateway          = false
enable_bastion              = false
enable_expressroute         = false
enable_er_gateway           = false
enable_application_gateway  = false
enable_hub_spoke            = false
enable_private_link_service = false
enable_traffic_manager      = false

# Keep cheap / free features
enable_network_watcher            = true
enable_nsg_flow_logs              = false
enable_route_table                = false
enable_private_dns                = false
enable_dns_resolver               = false
enable_postgres_subnet_delegation = false
enable_aci_subnet                 = false

# NSG flow logs storage (only needed if enable_nsg_flow_logs = true)
flow_log_storage_account_id         = ""
log_analytics_workspace_id          = ""
log_analytics_workspace_resource_id = ""
flow_log_retention_days             = 90

tags = {
  Environment = "dev"
  Project     = "azure-platform"
  ManagedBy   = "terraform"
  CostCentre  = "learning"
}
