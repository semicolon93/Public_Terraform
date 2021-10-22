provider "azurerm" {
  features {
    
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "kv_rg" {
  name     = var.kv_rg_name
  
}

resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = data.azurerm_resource_group.kv_rg.location
  resource_group_name         = data.azurerm_resource_group.kv_rg.name
  
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = true
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  sku_name = var.sku

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
        "backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update"
    ]

    key_permissions = [
      "backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"
    ]

    secret_permissions = [
      "backup", "delete", "get", "list", "purge", "recover", "restore", "set"
    ]

    storage_permissions = [
      "backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"
    ]
  }

  network_acls {
    default_action = var.network_acls
    bypass         = "AzureServices"
  }

  tags = {
    environment = var.environment
  }
}