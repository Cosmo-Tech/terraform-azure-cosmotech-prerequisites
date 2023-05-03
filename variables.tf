variable "tenant_id" {
  description = "The tenant id"
}

variable "subscription_id" {
  description = "The subscription id"
}

variable "client_id" {
  description = "The client id"
}

variable "client_secret" {
  description = "The client secret"
}

variable "platform_url" {
  description = "The platform url"
}

variable "identifier_uri" {
  description = "The platform identifier uri"
}

variable "project_stage" {
  description = "The platform stage"
  validation {
    condition = contains([
      "OnBoarding",
      "Dev",
      "QA",
      "IA",
      "EA",
      "Demo",
      "Prod"
    ], var.project_stage)
    error_message = "Stage must be either: OnBoarding, Dev, QA, IA, EA, Demo, Prod."
  }
}

variable "cluster_name" {
  type = string
}

variable "customer_name" {
  description = "The customer name"
}

variable "project_name" {
  description = "The project name"
}

variable "owner_list" {
  description = "List of mail addresses for App Registration owners"
  type        = list(string)
}

variable "audience" {
  description = "The App Registration audience type"
  validation {
    condition = contains([
      "AzureADMyOrg",
      "AzureADMultipleOrgs"
    ], var.audience)
    error_message = "Only AzureADMyOrg and AzureADMultipleOrgs are supported for audience."
  }
  default = "AzureADMultipleOrgs"
}

variable "user_app_role" {
  type = list(object({
    description  = string
    display_name = string
    id           = string
    role_value   = string
  }))
  description = "App role for azuread_application"
}

variable "webapp_url" {
  description = "The Web Application URL"
}

variable "create_restish" {
  description = "Create the Azure Active Directory Application for Restish"
  type        = bool
  default     = true
}

variable "create_powerbi" {
  description = "Create the Azure Active Directory Application for PowerBI"
  type        = bool
  default     = true
}

variable "location" {
  description = "The Azure location"
  default     = "West Europe"
}

variable "resource_group" {
  description = "Resource group to create which will contain created Azure resources"
  type        = string
}

variable "create_publicip" {
  description = "Create the public IP for the platform"
  type        = bool
  default     = true
}

variable "create_dnsrecord" {
  description = "Create the DNS record"
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "The DNS zone name to create platform subdomain. Example: api.cosmotech.com"
  type        = string
  default     = ""
}

variable "dns_zone_rg" {
  description = "The DNS zone resource group"
  type        = string
  default     = ""
}

variable "dns_record" {
  description = "The DNS zone name to create platform subdomain. Example: myplatform"
  type        = string
  default     = ""
}

variable "create_vnet" {
  description = "Create the Virtual Network for AKS"
  type        = bool
  default     = true
}

variable "vnet_iprange" {
  description = "The Virtual Network IP range. Minimum /26 NetMaskLength"
  type        = string
  default     = ""
}

variable "api_version_path" {
  description = "The API version path"
  type        = string
  default     = "/"
}

variable "managed_disk_name" {
  type    = string
  default = "cosmotech-database-disk"
}

variable "image_path" {
  type    = string
  default = "./cosmotech.png"
}

variable "create_webapp" {
  description = "Create the Azure Active Directory Application for WebApp"
  type        = bool
  default     = true
}

variable "create_secrets" {
  type    = bool
  default = true
}

variable "disk_size_gb" {
  type    = string
  default = "64"
}

variable "disk_sku" {
  type    = string
  default = "Premium_LRS"
}

variable "disk_tier" {
  type    = string
  default = "P6"
}

variable "kubernetes_version" {
  type    = string
  default = "1.25.5"
}