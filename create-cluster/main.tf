locals {
  dns_prefix        = "${var.cluster_name}-aks"
  cosmosdb_name     = "csm${var.cluster_name}"
  eventhub_name     = "evname-${var.cluster_name}"
  kusto_name        = "kusto${replace(var.resource_group, "/[[:^alnum:]]/", "")}"
  managed_disk_name = var.managed_disk_name != "" ? var.managed_disk_name : "cosmotech-database-disk"
  storage_name      = "${var.cluster_name}${random_string.random_storage_id.result}"
  acr_name          = replace(var.resource_group, "/[[:^alnum:]]/", "")
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}

resource "random_string" "random_storage_id" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_kubernetes_cluster" "phoenixcluster" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group
  dns_prefix                        = local.dns_prefix
  kubernetes_version                = var.kubernetes_version
  role_based_access_control_enabled = true
  private_cluster_enabled           = false
  tags                              = local.tags

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
    name                = "system"
    vm_size             = "Standard_A2_v2"
    max_pods            = 110
    max_count           = 6
    min_count           = 3
    enable_auto_scaling = true
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    vnet_subnet_id      = var.subnet_id
  }

  lifecycle {
    ignore_changes = [
      tags, azure_policy_enabled, microsoft_defender,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "basic" {
  name                  = "basic"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_F4s_v2"
  max_pods              = 110
  max_count             = 5
  min_count             = 1
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "basic" }
  vnet_subnet_id        = var.subnet_id
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpu" {
  name                  = "highcpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_F72s_v2"
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
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highmemory" {
  name                  = "highmemory"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_E16ads_v5"
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
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                  = "services"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_B4ms"
  max_pods              = 110
  max_count             = 5
  min_count             = 2
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "services" }
  vnet_subnet_id        = var.subnet_id
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = "db"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_D2ads_v5"
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
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "monitoring" {
  name                  = "monitoring"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixcluster.id
  vm_size               = "Standard_D2ads_v5"
  max_pods              = 110
  max_count             = 10
  min_count             = 1
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "monitoring" }
  vnet_subnet_id        = var.subnet_id
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_disk_access" "cosmotech-disk" {
  name                = "cosmotech-managed-disk-access"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = local.tags
}

resource "azurerm_managed_disk" "cosmotech-database-disk" {
  name                 = local.managed_disk_name
  resource_group_name  = var.resource_group
  disk_size_gb         = var.disk_size_gb
  location             = var.location
  storage_account_type = var.disk_sku
  tier                 = var.disk_tier
  create_option        = "Empty"

  public_network_access_enabled = false
  network_access_policy         = "AllowPrivate"
  disk_access_id                = azurerm_disk_access.cosmotech-disk.id

  tags = local.tags
}

resource "azurerm_role_assignment" "managed_disk_role" {
  scope                = azurerm_managed_disk.cosmotech-database-disk.id
  role_definition_name = "Owner"
  principal_id         = var.principal_id
}

resource "azurerm_storage_account" "storage_account" {
  name                            = local.storage_name
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
  tags                            = local.tags
  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny" # Same as for public_network_access
  }
}

resource "azurerm_container_registry" "acr" {
  name                      = local.acr_name
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
  data_endpoint_enabled         = false
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"
  zone_redundancy_enabled       = false
  tags                          = local.tags
}

resource "azurerm_private_endpoint" "storage_private_endpoint" {
  name                = "storage-privateendpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "privatestorageconnection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

resource "azurerm_private_endpoint" "disk_private_endpoint" {
  name                = "disk-privateendpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "privatediskconnection"
    private_connection_resource_id = azurerm_disk_access.cosmotech-disk.id # Must point to the disk access resource
    is_manual_connection           = false
    subresource_names              = ["disks"]
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}


resource "azurerm_cosmosdb_account" "cosmosdb" {
  count               = var.create_cosmosdb ? 1 : 0
  name                = local.cosmosdb_name
  location            = var.location
  kind                = "GlobalDocumentDB"
  resource_group_name = var.resource_group
  tags                = local.tags

  geo_location {
    location          = var.location
    failover_priority = 0
  }
  identity {
    type = "SystemAssigned"
  }
  public_network_access_enabled      = true
  enable_automatic_failover          = false
  enable_multiple_write_locations    = false
  is_virtual_network_filter_enabled  = false
  access_key_metadata_writes_enabled = true # Important to give 'write' (aka POST) rights !!!
  enable_free_tier                   = false
  analytical_storage_enabled         = false
  # create_mode                           = "Default"
  offer_type                            = "Standard"
  network_acl_bypass_for_azure_services = false
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
  }
  capabilities {
    name = "EnableServerless"
  }
  lifecycle {
    ignore_changes = [
      identity,
    ]
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql" {
  count               = var.create_cosmosdb ? 1 : 0
  name                = "phoenix-core"
  resource_group_name = azurerm_cosmosdb_account.cosmosdb[0].resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb[0].name
}

resource "azurerm_eventhub_namespace" "eventbus_uri" {
  name                          = local.eventhub_name
  resource_group_name           = var.resource_group
  location                      = var.location
  sku                           = "Standard"
  capacity                      = 2
  public_network_access_enabled = true
  tags                          = local.tags
}

resource "azurerm_kusto_cluster" "kusto" {
  count               = var.create_adx ? 1 : 0
  name                = local.kusto_name
  location            = var.location
  resource_group_name = var.resource_group
  sku {
    name     = "Standard_D12_v2"
    capacity = 2
  }
  identity {
    type = "SystemAssigned"
  }
  trusted_external_tenants      = ["*"]
  disk_encryption_enabled       = false
  streaming_ingestion_enabled   = true
  purge_enabled                 = false
  double_encryption_enabled     = false
  engine                        = "V2"
  public_network_access_enabled = true
  tags                          = local.tags
}