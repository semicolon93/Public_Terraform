provider "azurerm" {
  features {}
}

#creating resource group for virtual network
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

#create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_prefixes
  dns_servers         = ["8.8.8.8","168.63.129.16"]
}

#create subnet 
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet)
  name                 = var.subnet[count.index].subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet[count.index].subnet_address_prefixes

}
