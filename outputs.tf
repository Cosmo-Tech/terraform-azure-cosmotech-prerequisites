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
output "out_subnet" {
  value = one(azurerm_virtual_network.platform_vnet[*].subnet)
}