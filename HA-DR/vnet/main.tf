provider "azurerm" {
  features {}
}

#initializing backend
terraform {
  backend "azurerm" {
    /*resource_group_name = "RG_TF"
    storage_account_name = "storageaccounttf01"
    container_name = "container01"
    key = "vnet_snet.tfstate"*/
  }
}

#module to create virtual network
module "vnet_subnet" {
    source              = ".//module_vnet"
    resource_group_name = var.resource_group_name
    location            = var.location
    environment         = var.environment
    vnet_name           = var.vnet_name
    vnet_address_prefixes = var.vnet_address_prefixes
    subnet                = var.subnet
}