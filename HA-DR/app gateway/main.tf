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

module "module_appgw" {
    source = ".//module_appgw"
    environment             = var.environment
    resource_group_name     = var.resource_group_name
    location                = var.location
    vnet_name               = var.vnet_name
    vnet_rg                 = var.vnet_rg
    managed_identity_name   = var.managed_identity_name
    #keyvault_id            = var.keyvault_id
    #appgw_kv_sslcertificate_name         = var.appgw_kv_sslcertificate_name
    #appgw_kv_trustedrootcertificate_name = var.appgw_kv_trustedrootcertificate_name
    appgw_name              = var.appgw_name
    appgw_sku_name          = var.appgw_sku_name 
    appgw_sku_tier          = var.appgw_sku_tier
    #appgw_capacity         = var.appgw_capacity
    appgw_frontend_port     = var.appgw_frontend_port
    appgw_frontend_private_ip_address   = var.appgw_frontend_private_ip_address
    appgw_backend_address_pool_name     = var.appgw_backend_address_pool_name
    appgw_backend_ip_addresses          = var.appgw_backend_ip_addresses
    hostnames                = var.hostnames
    appgw_log_analytics_name = var.appgw_log_analytics_name
    appgw_log_analytics_sku  = var.appgw_log_analytics_sku
    appgw_frontend_subnet_name = var.appgw_frontend_subnet_name
    appgw_frontend_subnet_address_prefixes = var.appgw_frontend_subnet_address_prefixes
    log_analytics_workspace_id = var.log_analytics_workspace_id
}

