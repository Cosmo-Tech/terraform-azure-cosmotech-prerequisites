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

output "storage_account" {
  value = azurerm_storage_account.storage_account.name
}

output "azurerm_container_registry" {
  value = azurerm_container_registry.acr.name
}

output "managed_disk" {
  value = azurerm_managed_disk.cosmotech-database-disk.id
}