locals {
  backup_instance_name = "cosmo-backup-instance-${var.resource_group}"
  backup_policy_name   = "cosmo-backup-policy-${var.resource_group}"
}

resource "azurerm_data_protection_backup_vault" "vault" {
  name                = "cosmo-backup-vault"
  resource_group_name = var.resource_group
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_protection_backup_policy_disk" "backup_policy" {
  name     = local.backup_policy_name
  vault_id = azurerm_data_protection_backup_vault.vault.id

  backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
  default_retention_duration      = "P7D"

  retention_rule {
    name     = "Daily"
    duration = "P7D"
    priority = 25
    criteria {
      absolute_criteria = "FirstOfDay"
    }
  }

  retention_rule {
    name     = "Weekly"
    duration = "P7D"
    priority = 20
    criteria {
      absolute_criteria = "FirstOfWeek"
    }
  }
}

resource "azurerm_role_assignment" "snapshot_role" {
  scope                = var.resource_group_id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = azurerm_data_protection_backup_vault.vault.identity.0.principal_id
}

resource "azurerm_role_assignment" "backup_reader_role" {
  scope                = var.managed_disk_id
  role_definition_name = "Disk Backup Reader"
  principal_id         = azurerm_data_protection_backup_vault.vault.identity.0.principal_id
}

resource "azurerm_data_protection_backup_instance_disk" "instance" {
  name                         = local.backup_instance_name
  location                     = var.location
  vault_id                     = azurerm_data_protection_backup_vault.vault.id
  disk_id                      = var.managed_disk_id
  snapshot_resource_group_name = var.resource_group
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.backup_policy.id
}