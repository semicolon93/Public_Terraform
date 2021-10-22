provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    /*resource_group_name = "RG_TF"
    storage_account_name = "storageaccounttf01"
    container_name = "container01"
    key = "vnet_snet.tfstate"*/
  }
}

module "firewall" {
    source              = ".//module_firewall"
    vnet_rg = var.vnet_rg
    vnet_name = var.vnet_name
    fw_rg_name = var.fw_rg_name
    app_server_subnet_name = var.app_server_subnet_name
    fw_name = var.fw_name
    fw_subnet_address = var.fw_subnet_address
    fw_application_rule_collection_name = var.fw_application_rule_collection_name
    fw_application_rule_collection_priority = var.fw_application_rule_collection_priority
    fw_application_rule_collection_action = var.fw_application_rule_collection_action
    app_rule_name = var.app_rule_name
    app_rule_source_addresses = var.app_rule_source_addresses
    app_rule_target_fqdns = var.app_rule_target_fqdns
    app_rule_protocol_port = var.app_rule_protocol_port
    app_rule_protocol_type = var.app_rule_protocol_type
    fw_network_rule_collection_name = var.fw_network_rule_collection_name
    fw_network_rule_collection_priority = var.fw_network_rule_collection_priority
    fw_network_rule_collection_action = var.fw_network_rule_collection_action
    nw_rule_name = var.nw_rule_name
    nw_rule_source_addresses = var.nw_rule_source_addresses
    nw_rule_destination_ports = var.nw_rule_destination_ports
    nw_rule_destination_addresses = var.nw_rule_destination_addresses
    nw_rule_protocols = var.nw_rule_protocols
}
