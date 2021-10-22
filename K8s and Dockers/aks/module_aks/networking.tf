# Load NSG rules from CSV file 
locals {
    ns_rule = csvdecode(file(var.aks_nsg_rule_file))
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_name
  address_prefixes     = var.aks_subnet_address_cidr
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    #command = "SLEEP 30"
    command     = "Start-Sleep 50"
    interpreter = ["PowerShell", "-Command"]
  }
  triggers = {
    "before" = azurerm_kubernetes_cluster.aks_service.id
  }
}
/*

data "azurerm_resources" "aks_mc_nsg" {
  resource_group_name = azurerm_kubernetes_cluster.aks_service.node_resource_group
  type = "Microsoft.Network/networkSecurityGroups"
  depends_on = [azurerm_kubernetes_cluster.aks_service, null_resource.delay]
}

data "azurerm_network_security_group" "aks_nsg" {
  name = data.azurerm_resources.aks_mc_nsg.resources[0].name
  resource_group_name = azurerm_kubernetes_cluster.aks_service.node_resource_group
  depends_on = [azurerm_kubernetes_cluster.aks_service, null_resource.delay]
}

#Creating network security rules
resource "azurerm_network_security_rule" "ns_rules" {
  count                         = length(local.ns_rule)
  name                          = local.ns_rule[count.index].Name
  resource_group_name           = azurerm_kubernetes_cluster.aks_service.node_resource_group
  network_security_group_name   = data.azurerm_network_security_group.aks_nsg.name
  priority                      = local.ns_rule[count.index].Priority
  source_address_prefix         = local.ns_rule[count.index].SourceAddressPrefix != "" ? local.ns_rule[count.index].SourceAddressPrefix : null
  source_address_prefixes       = length(local.ns_rule[count.index].SourceAddressPrefixes) > 0 ? split(",",local.ns_rule[count.index].SourceAddressPrefixes) : null
  source_port_range             = local.ns_rule[count.index].SourcePortRange
  destination_address_prefix    = local.ns_rule[count.index].DestinationAddressPrefix != "" ? local.ns_rule[count.index].DestinationAddressPrefix : null 
  destination_address_prefixes  = length(local.ns_rule[count.index].DestinationAddressPrefixes) > 0 ? split (",", local.ns_rule[count.index].DestinationAddressPrefixes) : null
  destination_port_range        = (local.ns_rule[count.index].DestinationPortRange != "" ? (local.ns_rule[count.index].DestinationPortRange != "*" ? local.ns_rule[count.index].DestinationPortRange : "*") : null)
  destination_port_ranges       = length(local.ns_rule[count.index].DestinationPortRanges) > 0 ? split(",",local.ns_rule[count.index].DestinationPortRanges) : null
  protocol                      = local.ns_rule[count.index]. Protocol
  access                        = local.ns_rule[count.index].Access
  direction                     =local.ns_rule[count.index].Direction
}

#Assigning nsg to the service subnet
resource "azurerm_subnet_network_security_group_association" "service_assign_nsg" {
  
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = data.azurerm_network_security_group.aks_nsg.id
  depends_on                = [azurerm_network_security_rule.ns_rules]
}
*/