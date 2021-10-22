provider "azurerm" {
    features{}
}

#Fetch existing Subnet 
data "azurerm_subnet" "subnet" {
  name                  = var.subnet_name
  virtual_network_name  = var.vnet_name
  resource_group_name   = var.vnet_rg_name
  #depends_on            = [var.dependency]
}

# Load NSG rules from CSV file 
locals {
    ns_rule = csvdecode(file(var.nsg_rules_file))
}


# Create App Gateway NSG
resource "azurerm_network_security_group" "service_nsg"{
  name                  = var.nsg_name 
  location              = var.location
  resource_group_name   = var.vnet_rg_name
  #depends_on            = [var.dependency]
}

#Creating network security rules
resource "azurerm_network_security_rule" "ns_rules" {
  count                         = length(local.ns_rule)
  name                          = local.ns_rule[count.index].Name
  resource_group_name           = var.vnet_rg_name
  network_security_group_name   = azurerm_network_security_group.service_nsg.name
  priority                      = local.ns_rule[count.index].Priority
  source_address_prefix         = local.ns_rule[count.index].SourceAddressPrefix != "" ? local.ns_rule[count.index].SourceAddressPrefix : null
  source_address_prefixes       = length(local.ns_rule[count.index].SourceAddressPrefixes) >0 ? (local.ns_rule[count.index].SourceAddressPrefixes == "SubnetIPAddress" ? var.subnet_cidr : split(",",local.ns_rule[count.index].SourceAddressPrefixes)) : null
  source_port_range             = local.ns_rule[count.index].SourcePortRange
  destination_address_prefix    = local.ns_rule[count.index].DestinationAddressPrefix != "" ? local.ns_rule[count.index].DestinationAddressPrefix : null 
  destination_address_prefixes  = length(local.ns_rule[count.index].DestinationAddressPrefixes) > 0 ? (local.ns_rule[count.index].DestinationAddressPrefixes == "SubnetIPAddress" ? var.subnet_cidr : split (",", local.ns_rule[count.index].DestinationAddressPrefixes)) : null
  destination_port_range        = (local.ns_rule[count.index].DestinationPortRange != "" ? (local.ns_rule[count.index].DestinationPortRange != "*" ? local.ns_rule[count.index].DestinationPortRange : "*") : null)
  destination_port_ranges       = length(local.ns_rule[count.index].DestinationPortRanges) > 0 ? split(",",local.ns_rule[count.index].DestinationPortRanges) : null
  protocol                      = local.ns_rule[count.index]. Protocol
  access                        = local.ns_rule[count.index].Access
  direction                     =local.ns_rule[count.index].Direction
}

#Assigning nsg to the service subnet
resource "azurerm_subnet_network_security_group_association" "service_assign_nsg" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.service_nsg.id
  depends_on                = [azurerm_network_security_rule.ns_rules]
}







