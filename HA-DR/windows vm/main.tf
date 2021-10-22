provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    /*resource_group_name = "RG_TF"
    storage_account_name = "storageaccounttf01"
    container_name = "container01"
    key = "vnet_snet.tfstate"*/
  }
}

module "windows_server" {
  source              = ".//module_windows_server"
  ws_rg_name = var.ws_rg_name
  vnet_rg = var.vnet_rg
  vnet_name = var.vnet_name
  web_server = var.web_server
  db_server = var.db_server
}