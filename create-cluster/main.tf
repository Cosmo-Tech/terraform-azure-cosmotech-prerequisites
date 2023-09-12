locals {
  dns_prefix = "${var.cluster_name}-aks"
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
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