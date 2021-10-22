
#Creating subnet specific for the firewall
resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_rg.name
  address_prefixes       = var.fw_subnet_address
}

#Creating public ip to be assigned for the firewall
resource "azurerm_public_ip" "fw_ip" {
  name                = join("-", [var.fw_name, "-pip"])
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creating firewall
resource "azurerm_firewall" "firewall" {
  name                = var.fw_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_ip.id
  }
}


resource "azurerm_firewall_application_rule_collection" "example" {
  name                = var.fw_application_rule_collection_name
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_resource_group.rg.name
  priority            = var.fw_application_rule_collection_priority
  action              = var.fw_application_rule_collection_action

  rule {
    name = var.app_rule_name

    source_addresses = var.app_rule_source_addresses

    target_fqdns = var.app_rule_target_fqdns

    protocol {
      port = var.app_rule_protocol_port
      type = var.app_rule_protocol_type
    }
  }
}



resource "azurerm_firewall_network_rule_collection" "example" {
  name                = var.fw_network_rule_collection_name
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_resource_group.rg.name
  priority            = var.fw_network_rule_collection_priority
  action              = var.fw_network_rule_collection_action

  rule {
    name = var.nw_rule_name

    source_addresses = var.nw_rule_source_addresses

    destination_ports = var.nw_rule_destination_ports

    destination_addresses = var.nw_rule_destination_addresses

    protocols = var.nw_rule_protocols
  }
}