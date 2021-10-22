provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ws_rg" {
  name = var.ws_rg_name
}

data "azurerm_subnet" "server1_server_subnet" {
  name                 = var.server1_server_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_subnet" "server2_server_subnet" {
  name                 = var.server2_server_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}