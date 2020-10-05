output "resource_group_name" {
  description = "The name of the resource group in which resources are created"  
  value       = var.resource_group_name
}

output "administrator_login" {
  value       = var.administrator_login
  sensitive   = true
  description = "The mysql instance login for the admin."
}

# replica server outputs
output "replica_server_pw" {
  value       = random_password.replica_pw.result
  sensitive   = true
  description = "The postgresql replica server password for the admin."
}

output "replica_mysql_server_id" {
  description = "The replica Microsoft SQL Server ID"
  value       = element(concat(azurerm_mysql_server.replica.*.id, [""]), 0)
}

output "replica_mysql_server_fqdn" {
  description = "The fully qualified domain name of the replica Azure SQL Server" 
  value       = element(concat(azurerm_mysql_server.replica.*.fqdn, [""]), 0)
}

output "address_prefix_replica" {
  description = "returns a string"
  value       = data.azurerm_subnet.replica_subnet.address_prefix
}

output "id_replica" {
  description = "returns a string"
  value       = data.azurerm_subnet.replica_subnet.id
}

output "service_endpoints_replica" {
  description = "returns a list of string"
  value       = data.azurerm_subnet.replica_subnet.service_endpoints
}

output "pl_endpoint_network_policies_replica" {
  description = "returns a bool"
  value       = data.azurerm_subnet.replica_subnet.enforce_private_link_endpoint_network_policies
}

