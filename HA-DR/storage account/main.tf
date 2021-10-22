provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    #resource_group_name = "RG_TF"
    #storage_account_name = "storageaccounttf01"
    #container_name = "container01"
    #key = "vnet_snet.tfstate"
  }
}

#module to create storage account
module storage_account {
    source = ".//module_storageaccount"
    environment = var.environment
    storage_account_rg_name = var.storage_account_rg_name
    kv_name = var.kv_name
    kv_rg_name = var.kv_rg_name
    storage_name = var.storage_name
    account_tier = var.account_tier
    account_replication_type = var.account_replication_type
    vnet_name = var.vnet_name
    vnet_rg_name = var.vnet_rg_name
    allowed_subnet_ids = var.allowed_subnet_ids
    allowed_ips = var.allowed_ips
}