variable "tenant_id" {
  description = "The tenant id"
}

variable "subscription_id" {
  description = "The subscription id"
}

variable "client_id" {
  description = "The client id"
  default     = ""
}

variable "client_secret" {
  description = "The client secret"
  default     = ""
}

variable "platform_url" {
  description = "The platform url"
  default     = ""
}

variable "identifier_uri" {
  description = "The platform identifier uri"
  default     = ""
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
  type    = string
  default = ""
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
  default = [{
    description  = "Workspace Writer",
    display_name = "Workspace Writer",
    id           = "3f7ba86c-9940-43c8-a54d-0bfb706da136",
    role_value   = "Workspace.Writer"
    }, {
    description  = "Workspace Reader",
    display_name = "Workspace Reader",
    id           = "73ce2073-d918-4fe1-bc24-a4e69db07db8",
    role_value   = "Workspace.Reader"
    }, {
    description  = "Solution Writer"
    display_name = "Solution Writer"
    id           = "4f6e62a3-7f0a-4396-9620-ab465cd6577b"
    role_value   = "Solution.Writer"
    }, {
    description  = "Solution Reader"
    display_name = "Solution Reader"
    id           = "cf1a8625-38d9-417b-a5b9-a27c0014e740"
    role_value   = "Solution.Reader"
    }, {
    description  = "ScenarioRun Writer"
    display_name = "ScenarioRun Writer"
    id           = "ca8a2a19-3e09-48cc-976b-85ec9de4f68a"
    role_value   = "ScenarioRun.Writer"
    }, {
    description  = "ScenarioRun Reader"
    display_name = "ScenarioRun Reader"
    id           = "bdc8fe2a-73a8-477d-9efa-d8a37a4eb0f7"
    role_value   = "ScenarioRun.Reader"
    }, {
    description  = "Scenario Writer"
    display_name = "Scenario Writer"
    id           = "8fb9d03e-c46d-4003-a2a6-34d8b506e4e7"
    role_value   = "Scenario.Writer"
    }, {
    description  = "Scenario Reader"
    display_name = "Scenario Reader"
    id           = "e07dab65-4200-4502-8e36-79ca687320d9"
    role_value   = "Scenario.Reader"
    }, {
    description  = "Organization Writer"
    display_name = "Organization Writer"
    id           = "89d74995-095c-442f-bfda-06a77d3dbaa4"
    role_value   = "Organization.Writer"
    }, {
    description  = "Organization Reader"
    display_name = "Organization Reader"
    id           = "96213509-202a-497c-9f60-53c5f85268ec"
    role_value   = "Organization.Reader"
    }, {
    description  = "Dataset Writer"
    display_name = "Dataset Writer"
    id           = "c6e5d483-ec2c-4710-bf0c-78b0fda611dc"
    role_value   = "Dataset.Writer"
    }, {
    description  = "Dataset Reader"
    display_name = "Dataset Reader"
    id           = "454dc3f5-3012-45b3-bad6-975dae94338c"
    role_value   = "Dataset.Reader"
    }, {
    description  = "Ability to write connectors"
    display_name = "Connector Writer"
    id           = "e150953f-4835-4502-b95e-81d9ce97f591"
    role_value   = "Connector.Writer"
    }, {
    description  = "Organization Viewer"
    display_name = "Organization Viewer"
    id           = "ec5fdd3c-4df0-4c2f-bdad-0495a49f6e90"
    role_value   = "Organization.Viewer"
    }, {
    description  = "Organization User"
    display_name = "Organization User"
    id           = "bb9ffb73-997e-4320-8625-cfe45469aa3c"
    role_value   = "Organization.User"
    }, {
    description  = "Organization Modeler"
    display_name = "Organization Modeler"
    id           = "adcdb0a1-1588-4d2b-8657-364e544ac7e1"
    role_value   = "Organization.Modeler"
    }, {
    description  = "Organization Administrator"
    display_name = "Organization Admin"
    id           = "04b96a76-d77e-4a9d-967f-c55c857c478c"
    role_value   = "Organization.Admin"
    }, {
    description  = "Organization Collaborator"
    display_name = "Organization Collaborator"
    id           = "6f5ec4e3-1f2d-4502-837e-5d9754ea8acb"
    role_value   = "Organization.Collaborator"
    }, {
    description  = "Ability to develop connectors"
    display_name = "Connector Developer"
    id           = "428ab58e-ab61-4621-907c-d7908be72df7"
    role_value   = "Connector.Developer"
    }, {
    description  = "Ability to read connectors"
    display_name = "Connector Reader"
    id           = "2cd74037-3ccd-4ab7-929d-4afce87be2e4"
    role_value   = "Connector.Reader"
    }, {
    description  = "Platform Administrator"
    display_name = "Platform Admin"
    id           = "bb49d61f-8b6a-4a19-b5bd-06a29d6b8e60"
    role_value   = "Platform.Admin"
    }
  ]
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
  default     = "api.cosmotech.com"
}

variable "dns_zone_rg" {
  description = "The DNS zone resource group"
  type        = string
  default     = "phoenix"
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
  default     = "/v2/"
}

variable "managed_disk_name" {
  type    = string
  default = ""
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
  default = "1.25.6"
}

variable "create_cosmosdb" {
  type    = bool
  default = false
}

variable "create_adx" {
  type    = bool
  default = true
}

variable "create_babylon" {
  description = "Create the Azure Active Directory Application for Babylon"
  type        = bool
  default     = true
}

variable "cost_center" {
  type    = string
  default = "NA"
}

variable "create_backup" {
  type    = bool
  default = true
}