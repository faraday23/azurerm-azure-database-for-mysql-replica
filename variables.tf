##
# Required parameters
##

variable "location" {
  description = "Specifies the supported Azure location to create primary sql server resource"
  type        = string
}

variable "replica_server_location" {
  description = "Specifies the supported Azure location to create secondary sql server resource"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group to create the resource"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "srvr_id" {
  description = "identifier appended to srvr name for more info see https://github.com/openrba/python-azure-naming"
  type        = string
  default     = "01"
}

variable "srvr_id_replica" {
  description = "identifier appended to srvr name for more info see https://github.com/openrba/python-azure-naming"
  type        = string
  default     = "02"
}

variable "enable_db" {
  description = "toggles on/off MySQL Database within a MySQL Server"
  type        = bool
  default     = "false"
}

variable "sku_name" {
  type        = string
  description = "Azure database for MySQL sku name"
  default     = "GP_Gen5_2"
}

variable "storage_mb" {
  type        = number
  description = "Azure database for MySQL Sku Size"
  default     = "10240"
}

variable "mysql_version" {
  type        = string
  description = "MySQL version"
  default     = "8.0"
}

variable "storage_endpoint" {
    description = "This blob storage will hold all Threat Detection audit logs. Required if state is Enabled."
    type        = string
}

variable "storage_account_access_key" {
    description = "Specifies the identifier key of the Threat Detection audit storage account. Required if state is Enabled."
    type        = string
}

variable "log_retention_days" {
    description = "Specifies the number of days to keep in the Threat Detection audit logs"
    default     = "7"
}

variable "public_network_access_enabled" {
    description = "Whether or not public network access is allowed for this server."
}

variable "auto_grow_enabled" {
    description = "Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true."
    default     = "false"
}

variable "enable_private_endpoint" {
    description = "Enable/Disable private link endpoint. Azure Private Endpoint is a network interface that connects you privately and securely to a service powered by Azure Private Link."
    default     = "false"
}

variable "enable_firewall_rules" {
    description = "Manage an Azure SQL Firewall Rule"
    type        = bool
    default     = false
}

variable "enable_vnet_rule" {
    description = "Creates a virtual network rule to allows access to an Azure MySQL server."
    type        = bool
    default     = false
}

variable "firewall_rules" {
  description = "Range of IP addresses to allow firewall connections."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "allowed_subnets" {
  type        = list(string)
  description = "List of authorized subnet ids"
  default     = []
}

variable "enable_mysql_ad_admin" {
  description = "Set a user or group as the AD administrator for an MySQL server in Azure"
  type        = bool
  default     = false
}

variable "ad_admin_login_name" {
  description = "The login name of the azure ad admin for the replica."
  type        = string
}

variable "ad_admin_login_name_replica" {
  description = "The login name of the azure ad admin for the replica server."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of existing virtual network."
  type        = string
}

variable "virtual_network_name_replica" {
  description = "Name of existing virtual network for replica."
  type        = string
}

variable "subnet_name_primary" {
  description = "Name of new subnet virtual network."
  type        = string
}

variable "subnet_name_replica" {
  description = "Name of new subnet virtual network for replica."
  type        = string
}

##
# Optional Parameters
##

variable "administrator_login" {
  type        = string
  description = "Database administrator login name"
  default     = "az_dbadmin"
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  default     = "7"
}

variable "geo_redundant_backup_enabled" {
  type        = string
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not supported for the Basic tier."
  default     = "false"
}

variable "infrastructure_encryption_enabled" {
  type        = string
  description = "Whether or not infrastructure is encrypted for this server. Defaults to false. Changing this forces a new resource to be created."
  default     = "false"
}

variable "ssl_enforcement_enabled" {
  type        = string
  description = "Specifies if SSL should be enforced on connections. Possible values are true and false."
  default     = "true"
}

variable "enable_threat_detection_policy" {
  description = "Threat detection policy configuration, known in the API as Server Security Alerts Policy."
  type        = bool
  default     = false 
}

variable "enable_primary" {
  description = "Sets creation of primary mysql server. Possible values are true or false Defaults to false"
  type        = bool
  default     = true 
}

variable "enable_replica" {
  description = "Can be used to replicate existing servers. Possible values are true or false Defaults to false"
  type        = bool
  default     = false 
}

variable "vnet_resource_group_name" {
  description = "name of the resource group that contains the virtual network"
  type        = string
}

variable "vnet_replica_resource_group_name" {
  description = "name of the resource group that contains the virtual network for the replica"
  type        = string
}

##
# Required MySQL Server Parameters
##

variable "audit_log_enabled" {
  type        = string
  description = "The value of this variable is ON or OFF to Allow to audit the log."
  default     = "ON"
}

variable "character_set_server" {
  type        = string
  description = "Use charset_name as the default server character set."
  default     = "UTF8MB4"
}

variable "event_scheduler" {
  type        = string
  description = "Indicates the status of the Event Scheduler. It is always OFF for a replica server to keep the replication consistency."
}

variable "innodb_autoinc_lock_mode" {
  type        = string
  description = "The lock mode to use for generating auto-increment values."
  default     = "2"
}

variable "innodb_file_per_table" {
  type        = string
  description = "InnoDB stores the data and indexes for each newly created table in a separate .ibd file instead of the system tablespace. It cannot be updated any more for a master/replica server to keep the replication consistency."
  default     = "ON"
}

variable "join_buffer_size" {
  type        = string
  description = "The minimum size of the buffer that is used for plain index scans, range index scans, and joins that do not use indexes and thus perform full table scans."
  default     = "8000000"
}

variable "local_infile" {
  type        = string
  description = "This variable controls server-side LOCAL capability for LOAD DATA statements."
  default     = "ON"
}

variable "max_allowed_packet" {
  type        = string
  description = "The maximum size of one packet or any generated/intermediate string, or any parameter sent by the mysql_stmt_send_long_data() C API function."
  default     = "1073741824"
}

variable "max_connections" {
  type        = string
  description = "The maximum permitted number of simultaneous client connections. value 10-600"
  default     = "600"
}

variable "max_heap_table_size" {
  type        = string
  description = "This variable sets the maximum size to which user-created MEMORY tables are permitted to grow."
  default     = "64000000"
}

variable "performance_schema" {
  type        = string
  description = "The value of this variable is ON or OFF to indicate whether the Performance Schema is enabled."
  default     = "ON"
}

variable "replicate_wild_ignore_table" {
  type        = string
  description = "Creates a replication filter which keeps the slave thread from replicating a statement in which any table matches the given wildcard pattern. To specify more than one table to ignore, use comma-separated list."
  default     = "mysql.%,tempdb.%"
}

variable "slow_query_log" {
  type        = string
  description = "Enable or disable the slow query log"
  default     = "OFF"
}

variable "sort_buffer_size" {
  type        = string
  description = "Each session that must perform a sort allocates a buffer of this size."
  default     = "2000000"
}

variable "tmp_table_size" {
  type        = string
  description = "The maximum size of internal in-memory temporary tables. This variable does not apply to user-created MEMORY tables."
  default     = "64000000"
}

variable "transaction_isolation" {
  type        = string
  description = "The default transaction isolation level."
  default     = "READ-COMMITTED"
}

variable "query_store_capture_interval" {
    type        = string
    description = "The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
    default     = "15"
}

variable "query_store_capture_mode" {
    type        = string
    description = "The query store capture mode, NONE means do not capture any statements. NOTE: If performance_schema is OFF, turning on query_store_capture_mode will turn on performance_schema and a subset of performance schema instruments required for this feature."
    default     = "ALL"
}

variable "query_store_capture_utility_queries" {
    type        = string
    description = "Turning ON or OFF to capture all the utility queries that is executing in the system."
    default     = "YES"
}

variable "query_store_retention_period_in_days" {
    type        = string
    description = "The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
    default     = "7"
}

variable "query_store_wait_sampling_capture_mode" {
    type        = string
    description = "The query store wait event sampling capture mode, NONE means do not capture any wait events."
    default     = "ALL"
}

variable "query_store_wait_sampling_frequency" {
    type        = string
    description = "The query store wait event sampling frequency in seconds."
    default     = "30"
}

variable "create_mode" {
    type        = string
    description = "Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore. Defaults to Default"
}

variable "creation_source_server_id" {
    type        = string
    description = "the source server ID to use. use this only when creating a read replica server"
}

variable "mysql_config" {
  type        = map(string)
  description = "A map of mysql additional configuration parameters to values."
  default     = {}
}

locals {
  mysql_config = merge({
    audit_log_enabled                       = var.audit_log_enabled
    event_scheduler                         = var.create_mode == "Replica" ? var.event_scheduler : "ON"
    innodb_autoinc_lock_mode                = var.innodb_autoinc_lock_mode
    local_infile                            = var.local_infile
    max_allowed_packet                      = var.max_allowed_packet
    max_connections                         = var.max_connections
    performance_schema                      = var.performance_schema
    skip_show_database                      = "OFF"
    slow_query_log                          = var.slow_query_log
    transaction_isolation                   = var.transaction_isolation
    query_store_capture_interval            = var.query_store_capture_interval
    query_store_capture_mode                = var.query_store_capture_mode
    query_store_capture_utility_queries     = var.query_store_capture_utility_queries
    query_store_retention_period_in_days    = var.query_store_retention_period_in_days
    query_store_wait_sampling_capture_mode  = var.query_store_wait_sampling_capture_mode
    query_store_wait_sampling_frequency     = var.query_store_wait_sampling_frequency
  }, (var.mysql_version != "5.6" || var.mysql_version != "5.7" ? {} : {
    replicate_wild_ignore_table             = var.replicate_wild_ignore_table
    innodb_file_per_table                   = var.innodb_file_per_table
    join_buffer_size                        = var.join_buffer_size
    max_heap_table_size                     = var.max_heap_table_size
    sort_buffer_size                        = var.sort_buffer_size
    tmp_table_size                          = var.tmp_table_size
  }))
}

# Diagnostic setting - set retention days for logs and metrics
variable "storage_account" {
    type        = string
    description = "Name of storage account"
}

variable "sa_resource_group" {
    type        = string
    description = "Name of resource group the storage account resides in"
}

variable "mysql_slowlogs_retention_days" {
    type        = number
    description = "MySqlSlowLogs retention days. Default to 30."
    default     = 30
}

variable "mysql_auditlogs_retention_days" {
    type        = number
    description = "MySqlAuditLogs retention days. Default to 90."
    default     = 90
}

variable "mysql_metric_retention_days" {
    type        = number
    description = "MySql metric retention days. Default to 30."
    default     = 30
}










