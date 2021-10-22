provider "azurerm" {
  features {}
}

#Fetching existing resource group to deploy the resource
data "azurerm_resource_group" "rg" {
  name = var.fw_rg_name
}

#Fetching existing virtual network
data "azurerm_virtual_network" "vnet_rg" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

#Fetching existing subnet containing resources to be associated with route table
data "azurerm_subnet" "app_server_subnet" {
  name                 = var.app_server_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}