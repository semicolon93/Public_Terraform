
resource "azurerm_subnet" "appgw_frontend" {
  name                 = var.appgw_frontend_subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_name
  address_prefixes     = var.appgw_frontend_subnet_address_prefixes
}