locals {
  pre_name    = "Cosmo Tech "
  post_name   = " ${var.project_stage} For ${var.customer_name} ${var.project_name}"
  subnet_name = "default"
}

data "azuread_users" "owners" {
  user_principal_names = var.owner_list
}

# Azure AD
resource "azuread_application" "platform" {
  display_name     = "${local.pre_name}Platform${local.post_name}"
  identifier_uris  = var.identifier_uri != "" ? [var.identifier_uri] : null
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["${var.platform_url}${var.api_version_path}swagger-ui/oauth2-redirect.html"]
  }

  api {
    requested_access_token_version = 2
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to use the Cosmo Tech Platform with user account"
      admin_consent_display_name = "Cosmo Tech Platform Impersonate"
      enabled                    = true
      id                         = "6332363e-bcba-4c4a-a605-c25f23117400"
      type                       = "User"
      user_consent_description   = "Allow the application to use the Cosmo Tech Platform with your account"
      user_consent_display_name  = "Cosmo Tech Platform Usage"
      value                      = "platform"
    }
  }

  dynamic "app_role" {
    for_each = toset(var.user_app_role)
    iterator = app_role

    content {
      allowed_member_types = [
        "User",
        "Application"
      ]
      description  = app_role.value.description
      display_name = app_role.value.display_name
      id           = app_role.value.id
      enabled      = true
      value        = app_role.value.role_value
    }
  }
}

resource "azuread_service_principal" "platform" {
  application_id = azuread_application.platform.application_id
  # assignment required to secure Function Apps using thi App Registration as identity provider
  app_role_assignment_required = true

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "platform_password" {
  display_name          = "platform_secret"
  count                 = var.create_secrets ? 1 : 0
  application_object_id = azuread_application.platform.object_id
  end_date_relative     = "4464h"
}


resource "azuread_application" "network_adt" {
  display_name     = "${local.pre_name}Network and ADT${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = "AzureADMyOrg"
  tags             = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]
}

resource "azuread_service_principal" "network_adt" {
  depends_on                   = [azuread_service_principal.platform]
  application_id               = azuread_application.network_adt.application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "network_adt_password" {
  display_name          = "network_adt_secret"
  count                 = var.create_secrets ? 1 : 0
  application_object_id = azuread_application.network_adt.object_id
  end_date_relative     = "4464h"
}

resource "azuread_application" "swagger" {
  display_name     = "${local.pre_name}Swagger${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["${var.platform_url}${var.api_version_path}swagger-ui/oauth2-redirect.html"]
  }
}

resource "azuread_service_principal" "swagger" {
  depends_on                   = [azuread_service_principal.network_adt]
  application_id               = azuread_application.swagger.application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}


resource "azuread_application" "restish" {
  count            = var.create_restish ? 1 : 0
  display_name     = "${local.pre_name}Restish${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience
  tags             = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["http://localhost:8484/"]
  }
}

resource "azuread_service_principal" "restish" {
  depends_on                   = [azuread_service_principal.swagger]
  count                        = var.create_restish ? 1 : 0
  application_id               = azuread_application.restish[0].application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "restish_password" {
  display_name          = "restish_secret"
  count                 = var.create_restish && var.create_secrets ? 1 : 0
  application_object_id = azuread_application.restish[0].object_id
  end_date_relative     = "4464h"
}

resource "azuread_application" "powerbi" {
  count            = var.create_powerbi ? 1 : 0
  display_name     = "${local.pre_name}PowerBI${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = "AzureADMyOrg"
  tags             = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]
}

resource "azuread_service_principal" "powerbi" {
  depends_on                   = [azuread_service_principal.restish]
  count                        = var.create_powerbi ? 1 : 0
  application_id               = azuread_application.powerbi[0].application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "powerbi_password" {
  display_name          = "powerbi_secret"
  count                 = var.create_powerbi && var.create_secrets ? 1 : 0
  application_object_id = azuread_application.powerbi[0].object_id
  end_date_relative     = "4464h"
}

resource "azuread_application" "webapp" {
  display_name     = "${local.pre_name}Web App${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience
  count            = var.create_webapp ? 1 : 0

  tags = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.project_stage, var.customer_name, var.project_name, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["http://localhost:3000/scenario", "${var.webapp_url}/platform", "${var.webapp_url}/sign-in"]
  }
}

resource "azuread_service_principal" "webapp" {
  depends_on                   = [azuread_service_principal.webapp]
  application_id               = azuread_application.webapp[0].application_id
  app_role_assignment_required = false
  count                        = var.create_webapp ? 1 : 0

  tags = ["cosmotech", var.project_stage, var.customer_name, var.project_name, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

# create the Azure AD resource group
resource "azuread_group" "platform_group" {
  display_name     = "Cosmotech-Platform-${var.customer_name}-${var.project_name}-${var.project_stage}"
  owners           = data.azuread_users.owners.object_ids
  security_enabled = true
  members          = data.azuread_users.owners.object_ids
}

# Resource group
resource "azurerm_resource_group" "platform_rg" {
  name     = var.resource_group
  location = var.location
  tags = {
    vendor   = "cosmotech"
    stage    = var.project_stage
    customer = var.customer_name
    project  = var.project_name
  }
}

resource "azurerm_role_assignment" "rg_owner" {
  scope                = azurerm_resource_group.platform_rg.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.platform_group.object_id
}

# Public IP
resource "azurerm_public_ip" "publicip" {
  count               = var.create_publicip ? 1 : 0
  name                = "CosmoTech${var.customer_name}${var.project_name}${var.project_stage}PublicIP"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    vendor   = "cosmotech"
    stage    = var.project_stage
    customer = var.customer_name
    project  = var.project_name
  }
}

resource "azurerm_role_assignment" "publicip_contributor" {
  count                = var.create_publicip ? 1 : 0
  scope                = azurerm_resource_group.platform_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.network_adt.id
}

resource "azurerm_dns_a_record" "platform_fqdn" {
  depends_on          = [azurerm_public_ip.publicip]
  count               = var.create_publicip && var.create_dnsrecord ? 1 : 0
  name                = var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.publicip[0].id
}

# Virtual Network
resource "azurerm_virtual_network" "platform_vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = "CosmoTech${var.customer_name}${var.project_name}${var.project_stage}VNet"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_rg.name
  address_space       = [var.vnet_iprange]

  subnet {
    name           = local.subnet_name
    address_prefix = var.vnet_iprange
  }

  tags = {
    vendor   = "cosmotech"
    stage    = var.project_stage
    customer = var.customer_name
    project  = var.project_name
  }
}

resource "azurerm_role_assignment" "vnet_network_contributor" {
  count                = var.create_vnet ? 1 : 0
  scope                = azurerm_virtual_network.platform_vnet[0].id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.network_adt.id
}
