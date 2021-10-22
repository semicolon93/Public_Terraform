resource "azurerm_virtual_network" "vpngw_vnet" {
  name                = "Dev-QA-vnet"
  location            = data.azurerm_resource_group.vpngw_rg.location
  resource_group_name = data.azurerm_resource_group.vpngw_rg.name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "vpngw_subnet" {
  name                 = var.vpngw_subnet_name
  resource_group_name  = data.azurerm_resource_group.vpngw_rg.name
  virtual_network_name = azurerm_virtual_network.vpngw_vnet.name
  address_prefixes     = var.vpngw_subnet_address_prefixes
}