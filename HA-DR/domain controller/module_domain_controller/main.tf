provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "dc_rg"{ 
  name= var.dc_rg
}

data "azurerm_resource_group" "dm_rg"{ 
  name= var.dm_rg
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}