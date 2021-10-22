variable "environment" {
    type = string
}
variable "kv_name" {
    type = string
}
variable "kv_rg_name" {
    type = string
}
variable "vnet_rg" {
    type = string
}
variable "vnet_name" {
    type = string
}
variable "vpngw_subnet_name" {
    type = string
}
variable "vpngw_subnet_address_prefixes" {
    type = list
}
variable "vpngw_name" {
    type = string
}
variable "vpn_publicIP_sku" {
    type = string
}
variable "vpngw_active_active" {
    type = bool
}
variable "vpngw_enable_bgp" {
    type = bool
}
variable "vpngw_sku" {
    type = string
}
variable "vpngw_client_address_prefixes" {
    type = list
}
variable "vpngw_rootcertificate_name" {
    type = string
}
variable "log_analytics_workspace_id" {
    type = string
}

