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

#module to create nsg and network security rules
module "sql" {
    source = ".//module_sql_windows_server"
    ws_rg_name = var.ws_rg_name
    vnet_rg = var.vnet_rg
    vnet_name = var.vnet_name
    server_subnet_name = var.server_subnet_name
    server_subnet_cidr = var.server_subnet_cidr
    lbprivate_ip_address = var.lbprivate_ip_address
    server1_name = var.server1_name
    server2_name = var.server2_name
    server_size = var.server_size
    server_admin_username = var.server_admin_username
    server_admin_password = var.server_admin_password
    /*server_image_publisher = var.server_image_publisher
    server_image_offer = var.server_image_offer
    server_image_sku = var.server_image_sku
    server_image_version = var.server_image_version*/

    active_directory_domain_name = var.active_directory_domain_name
    active_directory_username = var.active_directory_username
    active_directory_password = var.active_directory_password
}