vnet_rg = "rg_vnet_tf"
vnet_name = "vnet_tf"
fw_rg_name = "rg_vnet_tf"
app_server_subnet_name = "bvmtappsn01"
fw_name = "bvmt_firewall_tf"
fw_subnet_address = ["10.0.1.0/24"]
fw_application_rule_collection_name = "bvmt_firewall_app_rule_tf"
fw_application_rule_collection_priority = 1000
fw_application_rule_collection_action = "Allow"
app_rule_name = "Allow_google"
app_rule_source_addresses = ["10.0.2.0/24"]
app_rule_target_fqdns = ["google.com"]
app_rule_protocol_port = "443"
app_rule_protocol_type = "Https"
fw_network_rule_collection_name = "bvmt_firewall_nw_rule_tf"
fw_network_rule_collection_priority = 1000
fw_network_rule_collection_action = "Allow"
nw_rule_name = "Allow_DNS"
nw_rule_source_addresses = ["10.0.2.0/24"]
nw_rule_destination_ports = ["53"]
nw_rule_destination_addresses = ["8.8.8.8"]
nw_rule_protocols = ["TCP","UDP"]