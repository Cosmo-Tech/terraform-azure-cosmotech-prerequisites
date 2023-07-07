output "client_certificate" {
  value     = azurerm_kubernetes_cluster.phoenixcluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.phoenixcluster.kube_config_raw

  sensitive = true
}

output "cluster" {
  value = azurerm_kubernetes_cluster.phoenixcluster
}

output "out_storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "out_storage_account_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

output "out_acr_login_server" {
  value     = azurerm_container_registry.acr.login_server
  sensitive = true
}

output "out_acr_login_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "out_acr_login_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "managed_disk_id" {
  value = azurerm_managed_disk.cosmotech-database-disk.id
}

output "cosmos_uri" {
  value     = var.create_cosmosdb ? azurerm_cosmosdb_account.cosmosdb[0].endpoint : ""
  sensitive = true
}

output "cosmos_key" {
  value     = var.create_cosmosdb ? azurerm_cosmosdb_account.cosmosdb[0].primary_key : ""
  sensitive = true
}

output "eventbus_uri" {
  value     = "amqps://${azurerm_eventhub_namespace.eventbus_uri.name}.servicebus.windows.net"
  sensitive = true
}

output "aks_phoenix_config" {
  value     = azurerm_kubernetes_cluster.phoenixcluster.kube_config
  sensitive = true
}

output "adx_uri" {
  value = azurerm_kusto_cluster.kusto.uri
}

output "adx_ingestion_uri" {
  value = azurerm_kusto_cluster.kusto.data_ingestion_uri
}