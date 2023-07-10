variable "location" {
  type = string
}

variable "application_id" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "managed_disk_name" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "principal_id" {
  type = string
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

variable "cluster_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.25.5"
}

variable "create_cosmosdb" {
  type    = bool
  default = false
}

variable "create_adx" {
  type        = bool
  default     = true
  description = "If false, adx_ingestion_uri and adx_uri must be set manually in create-platform module"
}