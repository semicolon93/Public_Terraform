/*
data "azurerm_subnet" "server_subnet" {
  name                 = var.server_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}*/

#Creating subnet for the SQL server
resource "azurerm_subnet" "server_subnet" {
  name                 = var.server_subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_name
  address_prefixes     = var.server_subnet_cidr
}