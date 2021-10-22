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

module "windows_server" {
    source              = ".//module_windows_server"
    ws_rg_name = var.ws_rg_name
    vnet_rg = var.vnet_rg
    vnet_name = var.vnet_name
    server1_server_subnet_name = var.server1_server_subnet_name
    server2_server_subnet_name = var.server2_server_subnet_name
    server1_server_name = var.server1_server_name
    server1_server_size = var.server1_server_size
    server1_server_admin_username = var.server1_server_admin_username
    server1_server_admin_password = var.server1_server_admin_password
    server1_server_image_publisher = var.server1_server_image_publisher
    server1_server_image_offer = var.server1_server_image_offer
    server1_server_image_sku = var.server1_server_image_sku
    server1_server_image_version = var.server1_server_image_version
    server2_server_name = var.server2_server_name
    server2_server_size = var.server2_server_size
    server2_server_admin_username = var.server2_server_admin_username
    server2_server_admin_password = var.server2_server_admin_password
    server2_server_image_publisher = var.server2_server_image_publisher
    server2_server_image_offer = var.server2_server_image_offer
    server2_server_image_sku = var.server2_server_image_sku
    server2_server_image_version = var.server2_server_image_version

    
    active_directory_domain_name = var.active_directory_domain_name
    active_directory_username = var.active_directory_username
    active_directory_password = var.active_directory_password
}