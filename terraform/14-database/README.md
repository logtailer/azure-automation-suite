<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.pgbouncer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_key_vault_secret.postgresql_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.redis_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_diagnostic_setting.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.db_storage_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_connections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_cpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgresql_cpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgresql_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_mysql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_configuration.require_ssl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_configuration.tls_version](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.allow_azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [azurerm_postgresql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server.read_replica](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.backup_retention](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.connection_throttle](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.log_checkpoints](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.log_connections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.log_disconnections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.max_wal_senders](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.ssl_min_version](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.wal_level](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.allow_azure_services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.allowed_ips](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_private_endpoint.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_redis_cache.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_redis_cache.replica](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_redis_linked_server.geo_replica](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_linked_server) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_azure_services"></a> [allow\_azure\_services](#input\_allow\_azure\_services) | Allow Azure services to access the PostgreSQL server | `bool` | `false` | no |
| <a name="input_db_backup_retention_days"></a> [db\_backup\_retention\_days](#input\_db\_backup\_retention\_days) | Number of days to retain PostgreSQL automated backups (7–35) | `number` | `14` | no |
| <a name="input_db_backup_storage_alert_gb"></a> [db\_backup\_storage\_alert\_gb](#input\_db\_backup\_storage\_alert\_gb) | Backup storage usage threshold in GB before alerting | `number` | `50` | no |
| <a name="input_enable_database"></a> [enable\_database](#input\_enable\_database) | Master toggle: create PostgreSQL flexible server resources | `bool` | `false` | no |
| <a name="input_enable_db_alerts"></a> [enable\_db\_alerts](#input\_enable\_db\_alerts) | Enable metric alerts for PostgreSQL backup storage | `bool` | `false` | no |
| <a name="input_enable_mysql"></a> [enable\_mysql](#input\_enable\_mysql) | MySQL | `bool` | `false` | no |
| <a name="input_enable_pgbouncer"></a> [enable\_pgbouncer](#input\_enable\_pgbouncer) | Deploy a PgBouncer connection pooler container alongside PostgreSQL | `bool` | `false` | no |
| <a name="input_enable_postgresql"></a> [enable\_postgresql](#input\_enable\_postgresql) | PostgreSQL | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Enable private endpoints for database resources | `bool` | `false` | no |
| <a name="input_enable_read_replica"></a> [enable\_read\_replica](#input\_enable\_read\_replica) | Create a read replica of the PostgreSQL flexible server in a secondary region | `bool` | `false` | no |
| <a name="input_enable_redis"></a> [enable\_redis](#input\_enable\_redis) | Redis | `bool` | `false` | no |
| <a name="input_enable_redis_replica"></a> [enable\_redis\_replica](#input\_enable\_redis\_replica) | Create a geo-replicated Redis secondary linked to the primary cache | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Key Vault resource ID to store database connection strings as secrets | `string` | `""` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for diagnostic settings | `string` | `""` | no |
| <a name="input_mysql_admin_login"></a> [mysql\_admin\_login](#input\_mysql\_admin\_login) | n/a | `string` | `"mysqladmin"` | no |
| <a name="input_mysql_admin_password"></a> [mysql\_admin\_password](#input\_mysql\_admin\_password) | n/a | `string` | `""` | no |
| <a name="input_mysql_allowed_ip_ranges"></a> [mysql\_allowed\_ip\_ranges](#input\_mysql\_allowed\_ip\_ranges) | Map of named IP ranges allowed to access MySQL (name -> {start, end}) | <pre>map(object({<br/>    start = string<br/>    end   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_mysql_backup_retention_days"></a> [mysql\_backup\_retention\_days](#input\_mysql\_backup\_retention\_days) | n/a | `number` | `7` | no |
| <a name="input_mysql_geo_redundant_backup"></a> [mysql\_geo\_redundant\_backup](#input\_mysql\_geo\_redundant\_backup) | n/a | `bool` | `false` | no |
| <a name="input_mysql_server_name"></a> [mysql\_server\_name](#input\_mysql\_server\_name) | n/a | `string` | `""` | no |
| <a name="input_mysql_sku_name"></a> [mysql\_sku\_name](#input\_mysql\_sku\_name) | n/a | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | n/a | `string` | `"8.0.21"` | no |
| <a name="input_postgres_max_connections_alert_threshold"></a> [postgres\_max\_connections\_alert\_threshold](#input\_postgres\_max\_connections\_alert\_threshold) | Active connection count threshold for PostgreSQL high-connections alert | `number` | `80` | no |
| <a name="input_postgresql_admin_login"></a> [postgresql\_admin\_login](#input\_postgresql\_admin\_login) | n/a | `string` | `"psqladmin"` | no |
| <a name="input_postgresql_admin_password"></a> [postgresql\_admin\_password](#input\_postgresql\_admin\_password) | n/a | `string` | `""` | no |
| <a name="input_postgresql_allowed_ip_ranges"></a> [postgresql\_allowed\_ip\_ranges](#input\_postgresql\_allowed\_ip\_ranges) | Map of named IP ranges allowed to access PostgreSQL (name -> {start, end}) | <pre>map(object({<br/>    start = string<br/>    end   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_postgresql_backup_retention_days"></a> [postgresql\_backup\_retention\_days](#input\_postgresql\_backup\_retention\_days) | n/a | `number` | `7` | no |
| <a name="input_postgresql_geo_redundant_backup"></a> [postgresql\_geo\_redundant\_backup](#input\_postgresql\_geo\_redundant\_backup) | n/a | `bool` | `false` | no |
| <a name="input_postgresql_server_name"></a> [postgresql\_server\_name](#input\_postgresql\_server\_name) | n/a | `string` | `""` | no |
| <a name="input_postgresql_sku_name"></a> [postgresql\_sku\_name](#input\_postgresql\_sku\_name) | n/a | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_postgresql_storage_mb"></a> [postgresql\_storage\_mb](#input\_postgresql\_storage\_mb) | n/a | `number` | `32768` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | n/a | `string` | `"15"` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for private endpoint placement | `string` | `""` | no |
| <a name="input_redis_cache_name"></a> [redis\_cache\_name](#input\_redis\_cache\_name) | n/a | `string` | `""` | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | n/a | `number` | `1` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | n/a | `string` | `"C"` | no |
| <a name="input_redis_replica_location"></a> [redis\_replica\_location](#input\_redis\_replica\_location) | Azure region for the Redis geo-replica | `string` | `"westus"` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | n/a | `string` | `"Standard"` | no |
| <a name="input_replica_location"></a> [replica\_location](#input\_replica\_location) | Azure region for the PostgreSQL read replica | `string` | `"westus"` | no |
| <a name="input_replica_sku_name"></a> [replica\_sku\_name](#input\_replica\_sku\_name) | SKU for the read replica (can be smaller than primary) | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group for database resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_warning_action_group_id"></a> [warning\_action\_group\_id](#input\_warning\_action\_group\_id) | Resource ID of the warning action group for alerts | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_fqdn"></a> [mysql\_fqdn](#output\_mysql\_fqdn) | FQDN of the MySQL flexible server |
| <a name="output_mysql_server_id"></a> [mysql\_server\_id](#output\_mysql\_server\_id) | Resource ID of the MySQL flexible server |
| <a name="output_postgresql_fqdn"></a> [postgresql\_fqdn](#output\_postgresql\_fqdn) | FQDN of the PostgreSQL flexible server |
| <a name="output_postgresql_server_id"></a> [postgresql\_server\_id](#output\_postgresql\_server\_id) | Resource ID of the PostgreSQL flexible server |
| <a name="output_redis_hostname"></a> [redis\_hostname](#output\_redis\_hostname) | Hostname of the Redis cache |
| <a name="output_redis_id"></a> [redis\_id](#output\_redis\_id) | Resource ID of the Redis cache |
| <a name="output_redis_primary_access_key"></a> [redis\_primary\_access\_key](#output\_redis\_primary\_access\_key) | Primary access key for the Redis cache |
<!-- END_TF_DOCS -->
