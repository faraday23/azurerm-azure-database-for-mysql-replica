# toggles on/off auditing and advanced threat protection policy for sql server
locals {
    if_threat_detection_policy_enabled = var.enable_threat_detection_policy ? [{}] : []                
}

# creates random password for postgresSQL admin account
resource "random_password" "replica_pw" {
  length      = 24
  special     = true
}

# MySQL Server Replica server - Default is false
resource "azurerm_mysql_server" "replica" {
  count               = var.enable_replica ? 1 : 0
  name                = "${var.names.product_name}-${var.replica_server_location}-${var.names.environment}-${var.srvr_id_replica}"
  location            = var.replica_server_location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  administrator_login          = var.administrator_login
  administrator_login_password = random_password.replica_pw.result

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.mysql_version

  auto_grow_enabled                 = var.auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
  create_mode                       = var.create_mode
  creation_source_server_id         = var.creation_source_server_id

  dynamic "threat_detection_policy" {
      for_each = local.if_threat_detection_policy_enabled
      content {
          storage_endpoint           = var.storage_endpoint
          storage_account_access_key = var.storage_account_access_key 
          retention_days             = var.log_retention_days
      }
  }
}

# Sets MySQL Configuration values on a MySQL Server.
resource "azurerm_mysql_configuration" "config_replica" {
  for_each            = local.mysql_config

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.replica.0.name
  value               = each.value
}

# Adding AD Admin to MySQL Server - Default is "false"
data "azurerm_client_config" "current" {}

resource "azurerm_mysql_active_directory_administrator" "aduser2" {
  count               = var.enable_replica && var.enable_mysql_ad_admin ? 1 : 0
  server_name         = azurerm_mysql_server.replica.0.name
  resource_group_name = var.resource_group_name
  login               = var.ad_admin_login_name_replica
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  depends_on = [azurerm_mysql_server.replica]
}

# MySQL Server - Existing vnet
data "azurerm_virtual_network" "replica_vnet" {
    name                = var.virtual_network_name_replica
    resource_group_name = var.vnet_replica_resource_group_name
}

# MySQL Replica Server - Existing subnet
data "azurerm_subnet" "replica_subnet" {
  name                 = var.subnet_name_replica
  resource_group_name  = var.vnet_replica_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.replica_vnet.name
}

# MySQL Virtual Network Rule - Default is "false"
resource "azurerm_mysql_virtual_network_rule" "vn_rule02" {
  count = var.enable_replica && var.enable_vnet_rule ? 1 : 0 

  name                = "${var.names.product_name}-${var.replica_server_location}-${var.srvr_id_replica}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.replica.0.name
  subnet_id           = data.azurerm_subnet.replica_subnet.id
}

resource "azurerm_mysql_firewall_rule" "fw02" {
  count               = var.enable_replica && var.enable_firewall_rules && length(var.firewall_rules) > 0 ? length(var.firewall_rules) : 0
  name                = element(var.firewall_rules, count.index).name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.replica.0.name
  start_ip_address    = element(var.firewall_rules, count.index).start_ip_address
  end_ip_address      = element(var.firewall_rules, count.index).end_ip_address
}
