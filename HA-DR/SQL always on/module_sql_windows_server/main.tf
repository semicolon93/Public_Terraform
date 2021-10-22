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

resource "azurerm_availability_set" "sqlavailabilityset" {
  name                         = "sqlavailabilityset"
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 5
  managed                      = true
}

data "azurerm_resource_group" "ws_rg" {
  name = var.ws_rg_name
}


