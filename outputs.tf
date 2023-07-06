output "out_platform_sp_client_id" {
  value = module.create-platform-prerequisite.out_platform_clientid
}

output "out_platform_sp_client_secret" {
  value = module.create-platform-prerequisite.out_platform_password
}

output "out_storage_account_name" {
  value = module.create-cluster.out_storage_account_name
}

output "out_storage_account_key" {
  value     = module.create-cluster.out_storage_account_key
  sensitive = true
}

output "out_acr_login_server" {
  value     = module.create-cluster.out_acr_login_server
  sensitive = true
}

output "out_acr_login_username" {
  value     = module.create-cluster.out_acr_login_username
  sensitive = true
}

output "out_acr_login_password" {
  value     = module.create-cluster.out_acr_login_password
  sensitive = true
}

output "managed_disk_id" {
  value = module.create-cluster.managed_disk_id
}

output "out_public_ip" {
  value = module.create-platform-prerequisite.out_public_ip
}

# for test purpose
output "out_subnet_id" {
  value = module.create-platform-prerequisite.out_subnet_id
}

output "out_public_ip_name" {
  value = module.create-platform-prerequisite.out_public_ip_name
}

output "out_ip_resource_group" {
  value = module.create-platform-prerequisite.out_ip_resource_group
}

output "out_networkadt_clientid" {
  value = module.create-platform-prerequisite.out_networkadt_clientid
}

output "out_network_adt_password" {
  value     = module.create-platform-prerequisite.out_network_adt_password
  sensitive = true
}

output "out_aks_phoenix_config" {
  value     = module.create-cluster.aks_phoenix_config
  sensitive = true
}

output "out_cosmos_uri" {
  value     = module.create-cluster.cosmos_uri
  sensitive = true
}

output "out_cosmos_key" {
  value     = module.create-cluster.cosmos_key
  sensitive = true
}

output "out_eventbus_uri" {
  value     = "amqps://${module.create-cluster.eventbus_uri}.servicebus.windows.net"
  sensitive = true
}