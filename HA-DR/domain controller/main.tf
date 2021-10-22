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

module "dc" {
    source              = ".//module_domain_controller"
    location = var.location
    dc_rg = var.dc_rg
    dm_rg = var.dm_rg
    vnet_rg = var.vnet_rg
    vnet_name = var.vnet_name
    dc_subnet = var.dc_subnet
    dm_subnet = var.dm_subnet
    active_directory_domain_name = var.active_directory_domain_name
    active_directory_netbios_name = var.active_directory_netbios_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    active_directory_username = var.active_directory_username
    active_directory_password = var.active_directory_password
    dc_name = var.dc_name
    dc_private_ip = var.dc_private_ip
    dc_size = var.dc_size
    dc_image_publisher = var.dc_image_publisher
    dc_image_offer = var.dc_image_offer
    dc_image_sku = var.dc_image_sku
    dc_image_version = var.dc_image_version
    dm_name = var.dm_name
    dm_size = var.dm_size
    dm_image_publisher = var.dm_image_publisher
    dm_image_offer = var.dm_image_offer
    dm_image_sku = var.dm_image_sku
    dm_image_version = var.dm_image_version
    }
