provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ws_rg" {
  name = var.ws_rg_name
}
/*
data "azurerm_subnet" "web_server_subnet" {
  count = length(var.web_server)
  name                 = var.web_server[count.index].subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}
*/
data "azurerm_subnet" "db_server_subnet" {
  count = length(var.db_server)
  name                 = var.db_server[count.index].subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

