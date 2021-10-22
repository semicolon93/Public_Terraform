variable fw_rg_name {
    type = string
}

variable vnet_name {
    type = string
}

variable vnet_rg {
    type = string
}

variable app_server_subnet_name {
    type = string
}

variable fw_name {
    type = string
}

variable fw_subnet_address {
    type = list
}

variable fw_application_rule_collection_name {
    type = string
}

variable fw_application_rule_collection_priority {
    type = number
}

variable fw_application_rule_collection_action {
    type = string
}

variable app_rule_name {
    type = string
}

variable app_rule_source_addresses {
    type = list
}

variable app_rule_target_fqdns {
    type = list
}

variable app_rule_protocol_port {
    type = string
}

variable app_rule_protocol_type {
    type = string
}

variable fw_network_rule_collection_name {
    type = string
}

variable fw_network_rule_collection_priority {
    type = string
}

variable fw_network_rule_collection_action {
    type = string
}

variable nw_rule_name {
    type = string
}

variable nw_rule_source_addresses {
    type = list
}

variable nw_rule_destination_ports {
    type = list   
}

variable nw_rule_destination_addresses {
    type = list
}

variable nw_rule_protocols {
    type = list
}



