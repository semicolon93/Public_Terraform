output "dependency" {
    value = "${azurerm_subnet_network_security_group_association.service_assign_nsg.id}"
}