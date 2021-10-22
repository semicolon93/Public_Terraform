
resource "azurerm_route_table" "route_table" {
  name                = join("-", [var.fw_name, "route_table"])
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_route" "route" {
  name                = join("-", [var.fw_name, "route"])
  resource_group_name = data.azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address  = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "associate" {
  subnet_id      = data.azurerm_subnet.app_server_subnet.id
  route_table_id = azurerm_route_table.route_table.id
}