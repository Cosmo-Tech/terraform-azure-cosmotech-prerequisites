module "create-platform-prerequisite" {
  source = "./create-platform-prerequisites"

  tenant_id        = var.tenant_id
  subscription_id  = var.subscription_id
  client_id        = var.client_id
  client_secret    = var.client_secret
  platform_url     = var.platform_url
  identifier_uri   = var.identifier_uri
  project_stage    = var.project_stage
  project_name     = var.project_name
  owner_list       = var.owner_list
  audience         = var.audience
  webapp_url       = var.webapp_url
  create_restish   = var.create_restish
  create_powerbi   = var.create_powerbi
  location         = var.location
  resource_group   = var.resource_group
  create_publicip  = var.create_publicip
  create_dnsrecord = var.create_dnsrecord
  dns_zone_name    = var.dns_zone_name
  dns_zone_rg      = var.dns_zone_rg
  dns_record       = var.dns_record
  create_vnet      = var.create_vnet
  vnet_iprange     = var.vnet_iprange
  api_version_path = var.api_version_path
  customer_name    = var.customer_name
  user_app_role    = var.user_app_role
  image_path       = var.image_path
  cost_center      = var.cost_center
}

module "create-cluster" {
  source = "./create-cluster"

  location            = var.location
  resource_group      = var.resource_group
  tenant_id           = var.tenant_id
  subscription_id     = var.subscription_id
  client_id           = var.client_id
  client_secret       = module.create-platform-prerequisite.out_platform_password
  managed_disk_name   = var.managed_disk_name
  cluster_name        = var.cluster_name
  project_stage       = var.project_stage
  project_name        = var.project_name
  customer_name       = var.customer_name
  cost_center         = var.cost_center
  application_id      = module.create-platform-prerequisite.out_platform_clientid
  subnet_id           = module.create-platform-prerequisite.out_subnet_id
  private_dns_zone_id = module.create-platform-prerequisite.out_private_dns_zone_id
  principal_id        = module.create-platform-prerequisite.out_platform_sp_object_id
  create_cosmosdb     = var.create_cosmosdb
  create_adx          = var.create_adx
  kubernetes_version  = var.kubernetes_version

  depends_on = [
    module.create-platform-prerequisite
  ]
}

module "create-backup" {
  source = "./create-backup"

  count             = var.enable-backup ? 1 : 0
  resource_group    = var.resource_group
  location          = var.location
  disk_id           = module.create-cluster.managed_disk_id
  resource_group_id = module.create-platform-prerequisite.out_resource_group_id
}