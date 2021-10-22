/*resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = ["10.0.0.0/8"]
  resource_group_name = var.vnet_rg
  dns_servers         = [var.dc_private_ip, "8.8.8.8","168.63.129.16"]
}*/

resource "azurerm_subnet" "dc" {
  name                 = "domain-controllers"
  address_prefixes     = var.dc_subnet
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "dm" {
  name                 = "domain-members"
  address_prefixes     = var.dm_subnet
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}