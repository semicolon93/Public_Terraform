provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    #resource_group_name = "RG_TF"
    #storage_account_name = "storageaccounttf01"
    #container_name = "container01"
    #key = "vnet_snet.tfstate"
  }
}

module vpngw {
    source = ".//module_vpngw"
    environment                   = var.environment
    kv_name                       = var.kv_name
    kv_rg_name                    = var.kv_rg_name
    vnet_rg                       = var.vnet_rg
    vnet_name                     = var.vnet_name    
    vpngw_subnet_name             = var.vpngw_subnet_name
    vpngw_subnet_address_prefixes = var.vpngw_subnet_address_prefixes
    vpngw_name                    = var.vpngw_name
    vpn_publicIP_sku              = var.vpn_publicIP_sku
    vpngw_active_active           = var.vpngw_active_active
    vpngw_enable_bgp              = var.vpngw_enable_bgp
    vpngw_sku                     = var.vpngw_sku
    vpngw_client_address_prefixes = var.vpngw_client_address_prefixes
    vpngw_rootcertificate_name    = var.vpngw_rootcertificate_name
    log_analytics_workspace_id    = var.log_analytics_workspace_id
}