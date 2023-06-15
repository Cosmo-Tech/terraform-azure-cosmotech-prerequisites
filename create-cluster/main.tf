locals {
  dns_prefix = "${var.cluster_name}-aks"
}

resource "azurerm_kubernetes_cluster" "phoenixcluster" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group
  dns_prefix                        = local.dns_prefix
  kubernetes_version                = var.kubernetes_version
  role_based_access_control_enabled = true
  private_cluster_enabled           = false

  network_profile {
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    network_plugin    = "azure"
    network_policy    = "calico"
  }

  http_application_routing_enabled = false

  service_principal {
    client_id     = var.application_id
    client_secret = var.client_secret
  }

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.subnet_id
  }

  lifecycle {
    ignore_changes = [
      tags, azure_policy_enabled,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_A2_v2"
  node_count            = 4
  max_pods              = 110
  max_count             = 6
  min_count             = 3
  enable_auto_scaling   = true
  mode                  = "System"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  vnet_subnet_id        = var.subnet_id
  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "basic" {
  name                  = "basic"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_F4s_v2"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "basic" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpu" {
  name                  = "highcpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_F72s_v2"
  node_count            = 0
  max_pods              = 110
  max_count             = 3
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "highcpu" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highmemory" {
  name                  = "highmemory"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_E16ads_v5"
  node_count            = 0
  max_pods              = 110
  max_count             = 3
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "highmemory" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                  = "services"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_A2m_v2"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "services" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = "db"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_D2ads_v5"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 2
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "db" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "monitoring" {
  name                  = "monitoring"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_D2ads_v5"
  node_count            = 0
  max_pods              = 110
  max_count             = 10
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "monitoring" }
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [
      tags, node_count,
    ]
  }
}

resource "azurerm_managed_disk" "cosmotech-database-disk" {
  name                 = var.managed_disk_name
  resource_group_name  = var.resource_group
  disk_size_gb         = var.disk_size_gb
  location             = var.location
  storage_account_type = var.disk_sku
  tier                 = var.disk_tier
  create_option        = "Empty"
}

resource "azurerm_storage_account" "storage_account" {
  name                            = var.resource_group
  resource_group_name             = var.resource_group
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  default_to_oauth_authentication = false
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = true
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
  public_network_access_enabled   = false # Must be false with private endpoints
  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny" # Same as for public_network_access
  }
}

resource "azurerm_container_registry" "acr" {
  name                      = var.resource_group
  resource_group_name       = var.resource_group
  location                  = var.location
  sku                       = "Standard"
  admin_enabled             = true
  quarantine_policy_enabled = false
  trust_policy = [{
    enabled = false
  }]
  retention_policy = [{
    days    = 7
    enabled = false
  }]
  # encryption = [ {
  #   enabled = false
  # } ]
  data_endpoint_enabled         = false
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"
  zone_redundancy_enabled       = false
}

resource "azurerm_private_endpoint" "storage_private_endpoint" {
  name                = "storage-privateendpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}